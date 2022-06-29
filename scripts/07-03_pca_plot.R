## Plot data on PCA plots

# see https://cran.r-project.org/web/packages/ggfortify/vignettes/plot_pca.html

save_plots <- TRUE

plot_pca <- function(treatment, timepoint_index = 1) {
  timepoint <- levels(factor(lplex_normal_list_timepoints[[timepoint_index]][[col_timepoint]]))
  df <- lplex_normal_list_timepoints[[timepoint_index]] %>%
    filter(!!sym(col_treatment) == treatment)
  
  # stop if there are not enough data
  if (nrow(df) < 2) {
    return(0)
  }
  
  df_filtered <- df %>%
    select(all_of(lplex_data_columns))
  
  # near empty columns cannot be evaluated by prcomp, so they are removed
  removed_columns <- c() # columns with one value or less (by index)
  for (i in 1:ncol(df_filtered)) {
    if (length(df_filtered[[i]]) < 2) {
      removed_columns <- c(removed_columns, i)
      print(length(df_filtered[[i]]))
    }
  }
  df <- select(df, -all_of(removed_columns))
  df_filtered <- select(df_filtered, -all_of(removed_columns))
  
  for (i in df_filtered) { # make sure there is enough variance for scale. = TRUE to work
    if (var(i) == 0) {
      stop("PCA plots are unavailable for dataframes that have 1 or more columns with 0 variance")
    }
  }
    
  pca_res <- prcomp(df_filtered, scale. = TRUE) # I don't know what scale does, but I think I need it
  plot <- autoplot(pca_res,
                   data = df,
                   colour = col_group, 
                   loadings = TRUE,
                   loadings.label = TRUE,
                   loadings.colour = "cornsilk3",
                   loadings.label.size = 2.5) +
          theme_light() +
          labs(title = paste("[TIMEPOINT: ", timepoint, "] ",
                             "[", col_treatment, ": ", treatment, "]",
                             sep = ""))
  return(plot)
}

plot_pca_cluster <- function(grouping = col_treatment, timepoint_index = 1, acc_only = FALSE, avg_acc = NULL, categorical = TRUE) {
  # https://stackoverflow.com/questions/35402850/how-to-plot-knn-clusters-boundaries-in-r
  # PLOT NOT SEPARATED BASED ON TREATMENT!!! (try clustering by TREATMENT)
  
  timepoint <- levels(factor(lplex_normal_list_timepoints[[timepoint_index]][["TIMEPOINT"]]))
  df <- lplex_normal_list_timepoints[[timepoint_index]] %>% #filter out NA values
    filter(!(!!sym(grouping) %in% possible_na_values))
  
  # change quantitative variables to batches
  if (!categorical) { # change it to numbers
    parse_failed <- FALSE
    x <- 0 # without this, it may return a weird error
    tryCatch( # make sure it only changes it to a number if it can be changed
      expr = {
        x <- parse_number(df[[grouping]])
      },
      warning = function(w) {
        parse_failed <- TRUE
      },
      finally = {
        df[[grouping]] <- x
      }
    )
    batches_num <- 5
    sig_figs <- 4
    grouping_range <- diff(range(df[[grouping]])) # get stats for batchmaking
    grouping_step <- grouping_range / batches_num
    batches <- c()
    prev <- range(df[[grouping]])[[1]]
    for (i in 1:batches_num) {
      x <- range(df[[grouping]])[[1]] + (grouping_step * i)
      batches <- c(batches, paste(signif(prev, sig_figs), "-", signif(x, sig_figs)))
      prev <- x
    }
    # put the data in the batches
    x <- df[[grouping]]
    y <- c()
    for (i in 1:length(df[[grouping]])) {
      datum <- x[i]
      if (datum == range(df[[grouping]])[[1]]) { # if it is the minimum, it will try to access index 0
        y <- c(y, batches[1])
      }
      datum_batch <- ceiling((datum - range(df[[grouping]])[[1]]) / grouping_step)
      y <- c(y, batches[datum_batch])
    }
    df[[grouping]] <- y # set the new column to be batches instead of numbers
  }
  
  # find the accuracy score and average it
  knn_iterations <- 40
  acc_score <- 0
  for (iter in 1:knn_iterations) {
    # this does knn clustering
    idx <- sample(1:nrow(df), size = ceiling(nrow(df) * 2/3)) # split into train and test dataframes
    train.idx <- 1:nrow(df) %in% idx
    test.idx <- ! 1:nrow(df) %in% idx
    train <- df[train.idx, lplex_data_columns]
    test <- df[test.idx, lplex_data_columns]
    labels <- df[train.idx, grouping]
    fit <- knn(train, test, labels[[grouping]]) # fit the knn model
    plot.df <- data.frame(test, predicted = fit) # format the data for comparison
    plot.df.actual <- data.frame(test, df[test.idx, grouping])
    full_data <- df[,lplex_data_columns]# format the data for PCA
    full_data <- data.frame(full_data, df[, grouping])
    plot.df.filtered <- full_data %>% 
      select(-!!sym(grouping))
    pca_res <- prcomp(plot.df.filtered, scale. = TRUE) # I don't know what scale does, but I think I need it
    
    # this calculates the accuracy of the clustering using F1
    # https://towardsdatascience.com/multi-class-metrics-made-simple-part-ii-the-f1-score-ebe8b2c2ca1
    predicted <- plot.df[["predicted"]]
    actual <- plot.df.actual[[grouping]]
    f1_scores <- data.frame(matrix(ncol = 4, nrow = 0))
    colnames(f1_scores) <- c("class", "precision", "recall", "f1")
    classes <- levels(factor(labels[[1]]))
    predicted_total <- list()
    actual_total <- list()
    for (i in 1:length(classes)) { # get the total number for each class predicted and actual
      if (classes[[i]] %in% names(table(predicted))) {
        predicted_total[[i]] <- table(predicted)[[classes[[i]]]]
      } else {
        predicted_total[[i]] <- 0
      }
      if (classes[[i]] %in% names(table(actual))) {
        actual_total[[i]] <- table(actual)[[classes[[i]]]]
      } else {
        actual_total[[i]] <- 0
      }
    }
    correct <- as.list(rep(0, length(classes)))
    for (i in 1:length(actual)) {
      if (actual[[i]] == predicted[[i]]) {
        correct[[match(actual[[i]], classes)]] <- correct[[match(actual[[i]], classes)]] + 1
      }
    }
    precision <- list() # calculate precision and accuracy per class
    recall <- list()
    for (i in 1:length(correct)) {
      precision[[i]] <- correct[[i]]/predicted_total[[i]]
      recall[[i]] <- correct[[i]]/actual_total[[i]]
    }
    precision[is.na(precision)] <- 0
    recall[is.na(recall)] <- 0
    f1_scores <- list() # get f1 scores per class
    for (i in 1:length(precision)) {
      p <- precision[[i]]
      r <- recall[[i]]
      f1_scores[[i]] <- (2 * ((p * r)/(p + r)))
    }
    f1_scores[is.na(f1_scores)] <- 0
    
    # summarize the scores into one single F1 score
    numerator <- 0
    for (i in 1:length(f1_scores)) {
      numerator <- numerator + (f1_scores[[i]] * actual_total[[i]])
    }
    accuracy_score <- numerator / Reduce('+', actual_total)
    accuracy_score <- accuracy_score * length(classes) # this makes sure that clustering with less variables doesn't guarantee it a higher score
    acc_score <- acc_score + accuracy_score
  }
  accuracy_score <- (acc_score / knn_iterations)

  if (acc_only) {  # only return the accuracy
    return(accuracy_score)
  } else if (!is.null(avg_acc)) { # set accuracy for graph manually (e.g. pca_automatic_clustering() so the accuracy on the graph is consistent with the rankings it provides)
    accuracy_score <- avg_acc
  }
  
  # plot the clustering
  plot <- autoplot(pca_res,
                   data = full_data,
                   colour = grouping,
                   loadings = TRUE,
                   loadings.label = TRUE,
                   loadings.colour = "cornsilk3",
                   loadings.label.size = 2.5,
                   frame = TRUE) +
    theme_light() +
    labs(title = paste("[TIMEPOINT: ", timepoint, "] ",
                      "[ACCURACY: ", round(accuracy_score, 4), "]",
                      sep = ""))
  return(plot)
}

# automatically find the best cluster and plot it,
# or return a list of the best clusters ranked
pca_automatic_clustering <- function(give_rankings = FALSE, timepoint_index = 1) {
  if (length(lplex_metadata_columns) == 0) { # make sure the metadata is specified
    stop("lplex_metadata_columns is empty")
  }
  clustering_cols <- c(lplex_metadata_columns, grep(col_group, colnames(lplex_normal)))
  
  acc_scores <- list()
  added <- 0
  all_categorical <- list() # keep track of which variables are categorical
  for (i in 1:length(clustering_cols)) { # for each column of metadata
    # categorical or quantitative column?
    input <- readline(paste("Categorical or Quantitative -",
                            colnames(lplex_normal)[clustering_cols][[i]],
                            "(c/q):"))
    if (input == "c") {categorical <- TRUE}
    else if (input == "q") {categorical <- FALSE}
    else {stop("Unknown Response")}
    acc <- plot_pca_cluster(colnames(lplex_normal)[[clustering_cols[[i]]]],
                                  timepoint_index = timepoint_index,
                                  acc_only = TRUE, categorical = categorical)
    acc_scores[[i]] <- acc # record the scores in a list
    added <- added + 1
    all_categorical[[i]] <- categorical # record whether the variables are quantitative or categorical so it doesn't have to ask twice
  }
  names(acc_scores) <- colnames(lplex_normal)[clustering_cols]
  
  if (give_rankings) {
    return(acc_scores) # return all the accuracy scores
  }
  
  cat(green("Accuracy Scores:\n"))
  print(acc_scores)
  
  # return the plot of the best one
  best_acc <- 0
  best_name <- ""
  best_categorical <- TRUE
  for (i in 1:length(acc_scores)) {
    datum_name <- names(acc_scores[i])
    datum_acc <- acc_scores[[i]]
    if (best_acc < datum_acc) {
      best_name <- datum_name
      best_acc <- datum_acc
      best_categorical <- all_categorical[[i]]
    }
  }
  
  return(plot_pca_cluster(grouping = best_name,
                          timepoint_index = timepoint_index,
                          avg_acc = best_acc,
                          categorical = best_categorical))
}

## OUTPUT ---

if (save_plots) {
  local({
    print("Saving pca plot images in output directory, deleting any old ones")
    do.call(file.remove, list(list.files("output/pca_plot", full.names = TRUE)))
    for (i in 1:length(lplex_normal_list_timepoints)) {
      for (j in 1:length(lplex_treatments)) {
        my_plot <- plot_pca(lplex_treatments[j], i)
        if (typeof(my_plot) == "double") { # sometimes, the function doesn't have enough data to return a graph
          cat(yellow("Plot skipped due to lack of data\n"))
          next
        }
        cat(green("Saving image\n"))
        ggsave(paste("output/pca_plot/", i, "_", j, ".", export_format, sep = ""),
               my_plot,
               device = export_format,
               width = 12,
               height = 7
        )
      }
    }
  })
}

rm(save_plots)

cat(blue("Run clustering using: pca_automatic_clustering(...) or plot_pca_cluster(...)\n"))

cat(cyan("Process complete\n"))

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

plot_pca_cluster <- function(grouping = col_treatment, timepoint_index = 1, acc_only = FALSE, avg_acc = NULL) {
  # https://stackoverflow.com/questions/35402850/how-to-plot-knn-clusters-boundaries-in-r
  
  # this does knn clustering
  timepoint <- levels(factor(lplex_normal_list_timepoints[[timepoint_index]][["TIMEPOINT"]]))
  df <- lplex_normal_list_timepoints[[timepoint_index]] %>% #filter out NA values
    filter(!(!!sym(grouping) %in% possible_na_values))
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
  # print(f1_scores)
  # print(actual_total)
  
  # summarize the scores into one single F1 score
  numerator <- 0
  for (i in 1:length(f1_scores)) {
    numerator <- numerator + (f1_scores[[i]] * actual_total[[i]])
  }
  accuracy_score <- numerator / Reduce('+', actual_total)
  
  # only return the accuracy, and set accuracy for the graph if an external function averaged it
  if (acc_only) {
    return(accuracy_score)
  } else if (!is.null(avg_acc)) {
    accuracy_score <- avg_acc
  }
  
  # plot the clustering
  plot <- autoplot(pca_res,
                   data = full_data,
                   colour = grouping,
                   loadings = TRUE,
                   loadings.label = TRUE,
                   loadings.colour = "cornsilk3",
                   loadings.label.size = 2.5) +
    theme_light() +
    labs(title = paste("[TIMEPOINT: ", timepoint, "] ",
                      "[ACCURACY: ", round(accuracy_score, 4), "]",
                      sep = ""))
  return(plot)
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

cat(cyan("Process complete\n"))

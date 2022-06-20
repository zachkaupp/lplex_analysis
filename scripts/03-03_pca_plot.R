## Plot data on PCA plots

# see https://cran.r-project.org/web/packages/ggfortify/vignettes/plot_pca.html

plot_pca <- function(stim, timepoint_index = 1) {
  timepoint <- levels(factor(lplex_normal_list_timepoints[[timepoint_index]][["TIMEPOINT"]]))
  df <- lplex_normal_list_timepoints[[timepoint_index]] %>%
    filter(STIM == stim)
  
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
                   colour = "GROUP", 
                   loadings = TRUE,
                   loadings.label = TRUE,
                   loadings.colour = "cornsilk3",
                   loadings.label.size = 2.5) +
          theme_light() +
          labs(title = paste("[TIMEPOINT: ", timepoint, "] ",
                             "[STIM: ", stim, "]",
                             sep = ""))
  return(plot)
}

plot_pca_cluster <- function(grouping = "STIM", timepoint_index = 1) { # TODO separate this based on stim, just like the normal one
  # https://stackoverflow.com/questions/35402850/how-to-plot-knn-clusters-boundaries-in-r
  timepoint <- levels(factor(lplex_normal_list_timepoints[[timepoint_index]][["TIMEPOINT"]]))
  df <- lplex_normal_list_timepoints[[timepoint_index]]
  idx <- sample(1:nrow(df), size = ceiling(nrow(df) * 2/3))
  train.idx <- 1:nrow(df) %in% idx
  test.idx <- ! 1:nrow(df) %in% idx
  train <- df[train.idx, lplex_data_columns]
  test <- df[test.idx, lplex_data_columns]
  labels <- df[train.idx, grouping]
  fit <- knn(train, test, labels[[grouping]])
  plot.df <- data.frame(test, predicted = fit)
  plot.df.actual <- data.frame(test, df[test.idx, grouping])
  plot.df.filtered <- plot.df %>%
    select(-predicted)
  pca_res <- prcomp(plot.df.filtered, scale. = TRUE) # I don't know what scale does, but I think I need it
  
  # this calculates the accuracy of the clustering
  predicted <- plot.df[["predicted"]]
  actual <- plot.df.actual[[grouping]]
  correct <- 0
  for (i in 1:length(predicted)) {
    if (predicted[i] == actual[i]) {
      correct <- correct + 1
    }
  }
  accuracy_score <- correct / length(predicted) # the relative amount the clustering got correct
  
  plot <- autoplot(pca_res,
                   data = plot.df,
                   colour = "predicted",
                   loadings = TRUE,
                   loadings.label = TRUE,
                   loadings.colour = "cornsilk3",
                   loadings.label.size = 2.5) +
    theme_light() +
    labs(title = paste("[TIMEPOINT: ", timepoint, "]",
                      "[ACCURACY: ", accuracy_score, "]",
                      sep = ""))
  return(plot)
}

local({
  print("Saving pca plot images in output directory, deleting any old ones")
  do.call(file.remove, list(list.files("output/pca_plot", full.names = TRUE)))
  for (i in 1:length(lplex_normal_list_timepoints)) {
    for (j in 1:length(lplex_stims)) {
      my_plot <- plot_pca(lplex_stims[j], i)
      if (typeof(my_plot) == "double") { # sometimes, the function doesn't have enough data to return a graph
        cat(yellow("Plot skipped due to lack of data\n"))
        next
      }
      cat(green("Saving image\n"))
      ggsave(paste("output/pca_plot/", i, "_", j, ".png", sep = ""),
             my_plot,
             device = "png",
             width = 12,
             height = 7
      )
    }
  }
})

print("Process complete")

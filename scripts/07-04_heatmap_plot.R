## Plot data on heatmaps

save_plots <- TRUE

plot_heatmap <- function(timepoint_index = 1) {
  df <- lplex_normal_list_timepoints[[timepoint_index]] # get the dataframe
  x <- df %>% # order the dataframe and select the necessary columns
    select(c(which(colnames(df) == col_treatment), which(colnames(df) == col_group), lplex_data_columns))

  for (i in x[3:ncol(x)]) { # make sure there is enough variance
    if (var(i) == 0) {
      stop("Heatmap plots are unavailable for dataframes that have 1 or more columns with 0 variance")
    }
  }
  
  options(dplyr.summarise.inform = FALSE)
  x_sum <- x %>% # get the medians for plotting
    group_by(!!sym(col_treatment), !!sym(col_group)) %>%
    summarize(across(everything(), median))
  x_sum$y <- paste(x_sum[[1]], sep = " - ") # this way of doing it is overcomplicated because it used to be needed
  x_sum <- x_sum[-1]
  x_groups <- x_sum[1]
  x_data <- as.matrix(x_sum[,-c(1,ncol(x_sum))])
  rownames(x_data) <- x_sum[[ncol(x_sum)]]
  x_data <- t(scale(x_data))
  heatmap_plot <- suppressWarnings(
    Heatmap(
      x_data,
      column_split = x_groups,
      name = paste("TIMEPOINT:",
                   levels(factor(lplex_normal_list_timepoints[[timepoint_index]][[col_timepoint]])))
    )
  )
  return(heatmap_plot)
}

## OUTPUT ---

if (save_plots) {
  local({
    print("Saving heatmap plot images in output directory, deleting any old ones")
    do.call(file.remove, list(list.files("output/heatmap_plot", full.names = TRUE)))
    for (i in 1:length(lplex_normal_list_timepoints)) {
      cat(green("Saving image\n"))
      png(paste("output/heatmap_plot/", i,".", export_format, sep = ""),
          width = 11, height = 7, units = "in", res = 400)
      draw(plot_heatmap(i))
      dev.off()
    }
  })
}

rm(save_plots)

cat(cyan("Process complete\n"))

## Plot single variables before/after normalization for more basic visualization needs

save_plots <- TRUE

singlevar_dotplot <- function(data_column, timepoint_index = 1, normalized = FALSE) {
  timepoint <- levels(factor(lplex_normal_list_timepoints[[timepoint_index]][[col_timepoint]]))
  
  # select either the normalized or unnormalized data
  if (normalized) {
    plot_data <- lplex_normal %>%
      filter(!!sym(col_timepoint) == timepoint) # select only one timepoint
  } else {
    plot_data <- lplex %>%
      filter(!!sym(col_timepoint) == timepoint) # select only one timepoint
  }
  
  # make sure extreme outliers don't make the data unviewable
  iqr <- IQR(plot_data[[data_column]])
  med <- median(plot_data[[data_column]])
  outliers <- 0
  for (i in 1:nrow(plot_data)) {
    if (plot_data[[data_column]][[i]] > (med + (2*iqr))) {
      plot_data[[data_column]][[i]] <- (med + (2*iqr))
      outliers <- outliers + 1
    } else if (plot_data[[data_column]][[i]] < (med - (2*iqr))) {
      plot_data[[data_column]][[i]] <- (med - (2*iqr))
      outliers <- outliers + 1
    }
  }
  
  # get the right x-axis label
  if (normalized) {
    x_axis_label <- paste(colnames(lplex)[[data_column]],
                          " -- log2fc (",
                          colnames(lplex)[[data_column]],
                          "/", control, ")", sep = "")
  } else {
    x_axis_label <- paste(colnames(lplex)[[data_column]],
                          " (nanograms)", sep = "")
  }
  
  # get the right color for the plot
  if (normalized) {plot_color <- "seagreen"} else {plot_color <- "red3"}
  
  # plot the data
  my_plot <- ggplot(plot_data,
                    aes(x = plot_data[[data_column]])) +
    geom_dotplot(dotsize = .7,
                 binwidth = ((1/20)*iqr),
                 color = plot_color,
                 fill = plot_color) +
    scale_y_continuous(NULL, breaks = NULL) +
    facet_wrap(vars(!!sym(col_treatment))) +
    labs(title = paste("[", col_timepoint, ": ", timepoint, "] ",
                       "[OUTLIERS (2 * IQR): ", outliers, "]", sep = "")) +
    xlab(x_axis_label) +
    theme_linedraw()
  
  return(my_plot)
}

## OUTPUT ---
if (save_plots) {
  local({ # local() puts variables in a local scope
    print("Saving singlevar dot plot nonnormalized images in output directory, deleting any old ones")
    do.call(file.remove, list(list.files("output/singlevar_plots/dot_plot/nonnormalized/", full.names = TRUE)))
    for (i in 1:length(lplex_normal_list_timepoints)) {
      for (j in lplex_data_columns) {
        cat(green("Saving image\n"))
        ggsave(paste("output/singlevar_plots/dot_plot/nonnormalized/", i, "_", j, ".", export_format, sep = ""),
               singlevar_dotplot(j, i, FALSE),
               device = export_format,
               width = 10, height = 7)
      }
    }
    print("Saving singlevar dot plot normalized images in output directory, deleting any old ones")
    do.call(file.remove, list(list.files("output/singlevar_plots/dot_plot/normalized/", full.names = TRUE)))
    for (i in 1:length(lplex_normal_list_timepoints)) {
      for (j in lplex_data_columns) {
        cat(green("Saving image\n"))
        ggsave(paste("output/singlevar_plots/dot_plot/normalized/", i, "_", j, ".", export_format, sep = ""),
               singlevar_dotplot(j, i, TRUE),
               device = export_format,
               width = 10, height = 7)
      }
    }
  })
}

rm(save_plots)

cat(cyan("Process complete\n"))

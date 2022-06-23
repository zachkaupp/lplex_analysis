## Plot single variables before/after normalization for more basic visualization needs

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
  
  # get the right color for the plot
  if (normalized) {plot_color <- "green"} else {plot_color <- "red"}
  
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
    xlab(colnames(lplex)[[data_column]])
  
  return(my_plot)
}


cat(cyan("Process complete"))

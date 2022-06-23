## Plot single variables before normalization for more basic visualization needs

singlevar_nonnormalized <- function(data_column, timepoint_index = 1) {
  timepoint <- levels(factor(lplex_normal_list_timepoints[[timepoint_index]][[col_timepoint]]))
  plot_data <- lplex %>%
    filter(!!sym(col_timepoint) == timepoint) # select only one timepoint
  iqr <- IQR(plot_data[[data_column]])
  outliers <- 0
  for (i in 1:nrow(plot_data)) {
    if (plot_data[[data_column]][[i]] > (2*iqr)) {
      plot_data[[data_column]][[i]] <- (2*iqr)
      outliers <- outliers + 1
    }
  }
  my_plot <- ggplot(plot_data,
                    aes(x = plot_data[[data_column]])) +
    geom_dotplot(dotsize = .7,
                 binwidth = ((1/20)*iqr),
                 color = "red",
                 fill = "red") +
    scale_y_continuous(NULL, breaks = NULL) +
    facet_wrap(vars(!!sym(col_treatment))) +
    labs(title = paste("[", col_timepoint, ": ", timepoint, "] ",
                       "[OUTLIERS: ", outliers, "]", sep = "")) +
    xlab(colnames(lplex)[[data_column]])
  
  return(my_plot)
}


cat(cyan("Process complete"))

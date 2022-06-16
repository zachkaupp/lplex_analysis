## Plot data on spider plots

plot_spider <- function(timepoint_index = 1) {
  plot <- lplex_normal_list_timepoints[[timepoint_index]] %>%
    mutate_at(vars(lplex_data_columns), rescale)
  ggradar(plot)
}

# i need to make a group column and only select that and the data columns for it to work
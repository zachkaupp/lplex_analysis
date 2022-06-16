## Plot means of data on spider plots

plot_spider <- function(timepoint_index = 1) {
  
  # create starting variables
  start_plot <- lplex_normal_list_timepoints[[timepoint_index]]
  spider_plot_columns <- c(which(colnames(start_plot) == "GROUP"), # this saves the column numbers for the group and all the data columns
                           lplex_data_columns)
  
  # make a dataframe with only the columns we need, and a row for
  # each group (by mean)
  small_plot <- start_plot %>%
    select(all_of(spider_plot_columns))
  small_plot_list <- list()
  added <- 0
  for (i in levels(factor(small_plot$GROUP))) {
    small_plot_list[[added + 1]] <- small_plot %>%
      filter(GROUP == i)
    added <- added + 1
  }
  mean_plot_list <- list()
  added <- 0
  for (i in small_plot_list) {
    x <- as_tibble(i) %>%
      select(-GROUP) %>%
      summarize(across(everything(), mean)) %>%
      mutate(GROUP = levels(factor(i$GROUP))) %>%
      select(GROUP, everything())
    mean_plot_list[[added + 1]] <- x
    added <- added + 1
  }
  mean_plot <- bind_rows(mean_plot_list)
  
  # rescale the dataframe into one ggradar can use (make values from 0-1)
  spider_plot <- mean_plot %>%
    mutate_at(vars(-GROUP), ~rescale(., from = range(select(mean_plot, -GROUP))))
  return(spider_plot)
}

# TODO
# - output into files
# - separate based on stim <- FIRST PRIORITY
# - give instructions at the end

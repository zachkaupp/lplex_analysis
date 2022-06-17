## Plot medians of data on spider plots

plot_spider <- function(stim, timepoint_index = 1) {
  
  # create starting variables
  start_plot <- lplex_normal_list_timepoints[[timepoint_index]]
  spider_plot_columns <- c(which(colnames(start_plot) == "GROUP"), # this saves the column numbers for the group and all the data columns
                           lplex_data_columns)
  
  # make a dataframe with only the columns we need, and a row for
  # each group (by median), after filtering by stim
  small_plot <- start_plot %>%
    filter(STIM == stim) %>% # filter for the specified stim
    select(all_of(spider_plot_columns)) # select only the necessary columns
  small_plot_list <- list()
  added <- 0
  for (i in levels(factor(small_plot$GROUP))) { # separate the dataframe by group
    small_plot_list[[added + 1]] <- small_plot %>%
      filter(GROUP == i)
    added <- added + 1
  }
  median_plot_list <- list()
  added <- 0
  for (i in small_plot_list) { # find the medians for the groups (one row per group)
    x <- as_tibble(i) %>%
      select(-GROUP) %>%
      summarize(across(everything(), median)) %>%
      mutate(GROUP = levels(factor(i$GROUP))) %>%
      select(GROUP, everything())
    median_plot_list[[added + 1]] <- x
    added <- added + 1
  }
  median_plot <- bind_rows(median_plot_list) # put it back into a final dataframe with the medians
  
  # rescale the dataframe, put it into ggradar, make it pretty, and add info
  spider_plot <- median_plot %>%
    mutate_at(vars(-GROUP), ~rescale(., from = range(select(median_plot, -GROUP)))) %>%
    ggradar (
      group.point.size = 2,
      group.line.width = .5,
      plot.title = paste("TIMEPOINT:",
                         levels(factor(lplex_normal_list_timepoints[[timepoint_index]]$TIMEPOINT)),
                         ", STIM: ", 
                         stim,
                         "-",
                         (nrow(select(small_plot,-GROUP)) *
                            ncol(select(small_plot,-GROUP))),
                         "data"),
      legend.title = "GROUP",
      values.radar = c("","","")
    )

  return(spider_plot) # return the complete spider plot
}

## OUTPUT ---

local({
  print("Saving spider plot images in output directory, deleting any old ones")
  do.call(file.remove, list(list.files("output/spider_plot", full.names = TRUE)))
  for (i in 1:length(lplex_normal_list_timepoints)) {
    for (j in 1:length(lplex_stims)) {
      ggsave(paste("output/spider_plot/", i, "_", j,".png", sep = ""),
             plot_spider(lplex_stims[[j]], i),
             device = "png",
             width = 10
      )
    }
  }
})

print("Process complete")

## Plot medians of data on spider plots

save_plots <- TRUE

plot_spider <- function(treatment, timepoint_index = 1) {

  # create starting variables
  start_plot <- lplex_normal_list_timepoints[[timepoint_index]]
  spider_plot_columns <- c(which(colnames(start_plot) == col_group), # this saves the column numbers for the group and all the data columns
                           lplex_data_columns)
  
  # make a dataframe with only the columns we need, and a row for
  # each group (by median), after filtering by treatment
  small_plot <- start_plot %>%
    filter(!!sym(col_treatment) == treatment) %>% # filter for the specified treatment
    select(all_of(spider_plot_columns)) # select only the necessary columns
  small_plot_list <- list()
  added <- 0
  for (i in levels(factor(small_plot[[col_group]]))) { # separate the dataframe by group
    small_plot_list[[added + 1]] <- small_plot %>%
      filter(!!sym(col_group) == i)
    added <- added + 1
  }
  median_plot_list <- list()
  added <- 0
  for (i in small_plot_list) { # find the medians for the groups (one row per group)
    x <- as_tibble(i) %>%
      select(-!!sym(col_group)) %>%
      summarize(across(everything(), median)) %>%
      mutate({{col_group}} := levels(factor(i[[col_group]]))) %>% # this should only save one group/level
      select(!!sym(col_group), everything())
    median_plot_list[[added + 1]] <- x
    added <- added + 1
  }
  median_plot <- bind_rows(median_plot_list) # put it back into a final dataframe with the medians
  
  # find the max and min of the dataframe
  log2fc_max <- max(select(median_plot, -!!sym(col_group)))
  log2fc_min <- min(select(median_plot, -!!sym(col_group)))
  log2fc_med <- median(c(log2fc_max, log2fc_min))
  
  # rescale the dataframe, put it into ggradar, make it pretty, and add info
  spider_plot <- median_plot %>%
    mutate_at(vars(-!!sym(col_group)), ~rescale(., from = range(select(median_plot, -!!sym(col_group))))) %>%
    ggradar (
      group.point.size = 2,
      group.line.width = .5,
      plot.title = paste("[TIMEPOINT: ",
                         levels(factor(lplex_normal_list_timepoints[[timepoint_index]][[col_timepoint]])),
                         "]  [",
                         col_treatment,
                         ": ", 
                         treatment,
                         "]  [",
                         (nrow(select(small_plot,-!!sym(col_group))) *
                            ncol(select(small_plot,-!!sym(col_group)))),
                         " data]",
                         sep = ""),
      legend.title = col_group,
      values.radar = c(paste("[", round(log2fc_min, 2), "]", sep = ""),
                       paste("[", round(log2fc_med, 2), "]", sep = ""),
                       paste("[", round(log2fc_max, 2), "]", sep = "")),
      gridline.min.colour = "lightpink1",
      gridline.mid.colour = "khaki",
      gridline.max.colour = "olivedrab2",
      gridline.min.linetype = "solid",
      gridline.max.linetype = "solid"
      #background.circle.colour = "white" # I want this, but it has bad visibility for a yellow group
    )

  return(spider_plot) # return the complete spider plot
}

## OUTPUT ---

if (save_plots) {
  local({
    print("Saving spider plot images in output directory, deleting any old ones")
    do.call(file.remove, list(list.files("output/spider_plot", full.names = TRUE)))
    for (i in 1:length(lplex_normal_list_timepoints)) {
      for (j in 1:length(lplex_treatments)) {
        cat(green("Saving image\n"))
        ggsave(paste("output/spider_plot/", i, "_", j,".", export_format, sep = ""),
               plot_spider(lplex_treatments[[j]], i),
               device = export_format,
               width = 11,
               height = 7
        )
      }
    }
  })
}

rm(save_plots)

cat(cyan("Process complete"))

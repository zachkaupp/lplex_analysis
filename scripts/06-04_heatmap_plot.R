## Plot data on heatmaps

save_plots <- TRUE

plot_heatmap <- function(timepoint_index = 1) {
  df <- lplex_normal_list_timepoints[[timepoint_index]] %>%
    select(!!sym(col_group), !!sym(col_treatment), lplex_data_columns) %>%
    pivot_longer(cols = -c(1,2), # make the data tidy
                 names_to = "ANALYTE",
                 values_to = "LOG2FC")
  heatmap_plot <- ggplot(df, aes(!!sym(col_treatment), ANALYTE, fill = LOG2FC)) +
    geom_tile() +
    scale_fill_gradient2(low = "springgreen",
                         mid = "skyblue",
                         high = "slateblue4",
                         midpoint = (median(df[["LOG2FC"]]) - IQR(df[["LOG2FC"]]))) +
    labs(title = paste("[TIMEPOINT: ", timepoint_index, "] ",
                       "[n: ", nrow(df), "] ",
                       "-- log2fc (ANALYTE/", control, ")", sep = "")) +
    facet_wrap(vars(!!sym(col_group))) +
    theme_linedraw()
  
  return(heatmap_plot)
}

## OUTPUT ---

if (save_plots) {
  local({
    print("Saving heatmap plot images in output directory, deleting any old ones")
    do.call(file.remove, list(list.files("output/heatmap_plot", full.names = TRUE)))
    for (i in 1:length(lplex_normal_list_timepoints)) {
      cat(green("Saving image\n"))
      ggsave(paste("output/heatmap_plot/", i,".", export_format, sep = ""),
             plot_heatmap(i),
             device = export_format,
             width = 11,
             height = 7
      )
    }
  })
}

rm(save_plots)

cat(cyan("Process complete\n"))

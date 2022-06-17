## Plot data on PCA plots

# see https://cran.r-project.org/web/packages/ggfortify/vignettes/plot_pca.html

plot_pca <- function(timepoint_index = 1) {
  timepoint <- levels(factor(lplex_normal_list_timepoints[[timepoint_index]]$TIMEPOINT))
  df <- lplex_normal_list_timepoints[[timepoint_index]]
  df_filtered <- df %>%
    select(all_of(lplex_data_columns))
  pca_res <- prcomp(df_filtered, scale. = TRUE) # I don't know what scale does
  plot <- autoplot(pca_res,
                   data = df,
                   colour = "GROUP",
                   loadings = TRUE,
                   loadings.label = TRUE,
                   loadings.colour = "cornsilk3",
                   loadings.label.size = 2.5) +
          theme_light() +
          labs(title = paste("TIMEPOINT:", timepoint))
  return(plot)
}

local({
  print("Saving pca plot images in output directory, deleting any old ones")
  do.call(file.remove, list(list.files("output/pca_plot", full.names = TRUE)))
  for (i in 1:length(lplex_normal_list_timepoints)) {
    ggsave(paste("output/pca_plot/", i, ".png", sep = ""),
           plot_pca(i),
           device = "png",
           width = 12,
           height = 7
           )
  }
})

print("Process complete")

## Plot data on violin plots

plot_violin <- function(cytokine = "IL-1β", timepoint_index = 1) {
  
  # make the plot, most of this is for appearance
  x <- ggplot(lplex_normal_list_timepoints[[timepoint_index]],
              aes(x = STIM,
                  y = lplex_normal_list_timepoints[[timepoint_index]][[cytokine]],
                  fill = STIM)) + 
    geom_violin(trim = FALSE, color = "black", scale = "width") +
    geom_boxplot(width = .7, outlier.shape = NA, color = "darkblue", fill = NA) +
    geom_dotplot(binaxis = 'y', stackdir = "center",
                 dotsize = .3, alpha = .5,
                 binwidth = (diff(range(lplex_normal_list_timepoints[[timepoint_index]][[cytokine]]))/20), # this makes sure the the dots stay around the same size for every cytokine, it is a problem otherwise
                 color = "black",
                 fill = "white") + 
    facet_wrap(~GROUP) +
    labs(title = paste("TIMEPOINT",
                       levels(factor(lplex_normal_list_timepoints[[timepoint_index]]$TIMEPOINT)),
                       "-- log2fc",
                       cytokine,
                       "/ NIL")) +
    xlab("STIM") +
    ylab(cytokine) +
    theme_light()
  return(x) # return the complete violin plot
}

print(paste("To access plot, run plot_violin(cytokine, timepoint_index). Choose from",
            length(lplex_normal_list_timepoints), "TIMEPOINTs."))
print("Plots are also stored in output/violin_plot")

## OUTPUT ---

print("Saving violin plot images in output directory, deleting any old ones")
do.call(file.remove, list(list.files("output/violin_plot", full.names = TRUE)))
for (i in 1:length(lplex_normal_list_timepoints)) {
  for (j in lplex_data_columns) {
    # warnings are suppressed because it often warns that it is excluding data
    # when there aren't enough data points, and that isn't a big deal
    suppressWarnings(ggsave(paste("output/violin_plot/", i, "_",
                 j - (min(lplex_data_columns) - 1), # start counting from 1
                 ".png", sep = ""),
           plot_violin(colnames(lplex_normal[j]),i),
           device = "png"))
  }
}


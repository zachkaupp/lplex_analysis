## Plot data on violin plots

save_plots <- TRUE

plot_violin <- function(cytokine, timepoint_index = 1) {
  n <- nrow(lplex_normal_list_timepoints[[timepoint_index]])
  
  # make the plot, most of this is for appearance
  x <- ggplot(lplex_normal_list_timepoints[[timepoint_index]],
              aes(x = !!sym(col_treatment),
                  y = lplex_normal_list_timepoints[[timepoint_index]][[cytokine]],
                  fill = !!sym(col_treatment))) + 
    geom_violin(trim = FALSE, color = "black", scale = "width", width = .7) +
    geom_boxplot(width = 1, outlier.shape = NA, color = "darkblue", fill = NA) +
    geom_dotplot(binaxis = 'y', stackdir = "center",
                 dotsize = .3, alpha = .8,
                 binwidth = (diff(range(lplex_normal_list_timepoints[[timepoint_index]][[cytokine]]))/20), # this makes sure the the dots stay around the same size for every cytokine, it is a problem otherwise
                 color = "black",
                 fill = "white") +
    geom_line(aes(group = !!sym(col_id)),
              alpha = ((1.005 ^ (-1 * (n+50))) - (.9 * (1.1 ^ (-1 * (n+50))))),
              colour = "darkturquoise") +
    facet_wrap(vars(!!sym(col_group))) +
    labs(title = paste("[TIMEPOINT: ",
                       levels(
                         factor(
                           lplex_normal_list_timepoints[[timepoint_index]][[col_timepoint]])),
                       "]  [",
                       cytokine,
                       "]  [n: ",
                       n,
                       "]",
                       sep = "")) +
    xlab(col_treatment) +
    ylab(paste(cytokine, " -- log2fc (",  cytokine, "/", control, ")", sep = "")) +
    theme_linedraw()
  return(x) # return the complete violin plot
}

## OUTPUT ---
if (save_plots) {
  local({ # local() puts variables in a local scope
    print("Saving violin plot images in output directory, deleting any old ones")
    do.call(file.remove, list(list.files("output/violin_plot", full.names = TRUE)))
    for (i in 1:length(lplex_normal_list_timepoints)) {
      for (j in lplex_data_columns) {
        # warnings are suppressed because it often warns that it is excluding data
        # when there aren't enough data points, and that isn't a big deal
        cat(green("Saving image\n"))
        suppressWarnings(ggsave(paste("output/violin_plot/", i, "_",
                                      j, # cytokine index
                                      ".", export_format, sep = ""),
                                plot_violin(colnames(lplex_normal[j]),i),
                                device = export_format,
                                width = 10,
                                height = 7))
      }
    }
  })
}

rm(save_plots)

cat(cyan("Process complete\n"))

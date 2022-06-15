## Plot data on violin plots

cytokine_list <- list("IL-1β", "IFN-α2", "IFN-γ", "TNF-α",	"MCP-1",	"IL-6",
                       "IL-8", "IL-10 (B3)","IL-12p70",	"IL-17A",	"IL-18",
                       "IL-23",	"IL-33")

plot_violin <- function(cytokine = "IL-1β", timepoint_index = 1) {
  
  # make the plot, most of this is for appearance
  x <- ggplot(lplex_normal_list_timepoints[[timepoint_index]],
              aes(x = STIM,
                  y = lplex_normal_list_timepoints[[timepoint_index]][[cytokine]],
                  fill = STIM)) + 
    geom_violin(trim = FALSE, color = "black") +
    geom_boxplot(width = .7, outlier.shape = NA, color = "darkblue", fill = NA) +
    geom_dotplot(binaxis = 'y', stackdir = "center",
                 dotsize = .7, alpha = .7,
                 binwidth = (diff(range(lplex_normal_list_timepoints[[timepoint_index]][[cytokine]]))/20), # this makes sure the the dots stay around the same size for every cytokine, it is a problem otherwise
                 color = "black",
                 fill = "white") + 
    facet_wrap(~GROUP) +
    labs(title = paste("TIMEPOINT",
                       levels(factor(lplex_normal_list_timepoints[[timepoint_index]]$TIMEPOINT)),
                       "-- log-2-fold-change")) +
    xlab("STIM") +
    ylab(cytokine) +
    theme_light()
  #print(paste("Plotting", cytokine, "for TIMEPOINT", # this will tell you when it plots, if you want that
              #levels(factor(lplex_normal_list_timepoints[[timepoint_index]]$TIMEPOINT))))
  return(x) # return the complete violin plot
}

print(paste("To access plot, run plot_violin(cytokine, timepoint_index). Choose from",
            length(lplex_normal_list_timepoints), "TIMEPOINTs."))
print("Plots are also stored in output/violin_plot")

## OUTPUT ---




## Plot data on violin plots

cytokine_list <- list("IL-1β", "IFN-α2", "IFN-γ", "TNF-α",	"MCP-1",	"IL-6",
                       "IL-8", "IL-10 (B3)","IL-12p70",	"IL-17A",	"IL-18",
                       "IL-23",	"IL-33")

plot_violin <- function(cytokine = "IL-1β", timepoint_index = 1) {
  x <- ggplot(lplex_normal_list_timepoints[[timepoint_index]],
              aes(x = STIM,
                  y = lplex_normal_list_timepoints[[timepoint_index]][[cytokine]])) + 
    geom_violin() +
    geom_dotplot(binaxis = 'y', stackdir = "center",
                 dotsize = 1, alpha = .7, binwidth = .2) +
    facet_wrap(~GROUP) +
    labs(title = paste("Cytokine", cytokine, "at TIMEPOINT",
                       levels(factor(lplex_normal_list_timepoints[[timepoint_index]]$TIMEPOINT)),
                       "between GROUPS, log-2-fold-change")) +
    xlab("STIM") +
    ylab(cytokine)
  #print(paste("Plotting", cytokine, "for TIMEPOINT",
              #levels(factor(lplex_normal_list_timepoints[[timepoint_index]]$TIMEPOINT))))
  return(x)
}

print(paste("To access plot, run plot_violin(cytokine, timepoint_index). Choose from",
            length(lplex_normal_list_timepoints), "TIMEPOINTs."))

plot_list <- list()
#added <- 0
for (i in cytokine_list) {
  plot_list <- c(plot_list, list(plot_violin(i,1)))
  #added <- added + 1
}

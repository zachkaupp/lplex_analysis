# Violin plots

`07-01_violin_plot.R` defines 1 function:

```r
plot_violin <- function(cytokine, timepoint_index = 1) {
    # the function returns a violin plot, separated by
    # treatment, at the given cytokine/analyte and
    # timepoint_index
    
    # ARGUMENTS:
    # cytokine = str, the name of the column containing the
    #     analyte to plot for
    # timepoint_index = int, the timepoint index to plot for
}
```

#### Layering

Violin plots are layered in this order, bottom first:

* Violin plot (maximum width is fixed)
* Box plot (to show quartiles)
* Dot plot (to show individual datapoints)
* Lines (connecting the datapoints by ID)

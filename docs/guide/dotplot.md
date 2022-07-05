# Dot plots

`05_singlevar_dotplot.R` defines 1 function:

```r
singlevar_dotplot <- function(data_column, timepoint_index = 1, normalized = FALSE) {
    # this function plots a dot plot of the distribution of
    # data for a specified column and timepoint

    # ARGUMENTS:
    # data_column = the "name" of the column containing data
    #     for the analyte that should be plotted
    # timepoint_index = the index of the timepoint to be
    #     plotted (e.g. 1,2, etc.)
    # normalized = boolean to determine whether the
    #     or the pre-normalized data should be plotted
}
```

#### Outlier Handling

`singlevar_dotplot` plots every point, and it does not exclude the outliers that it counts at the top of the graph. Instead, the outliers are pushed to the edge of the graph, as far over as they can be plotted on their respective side.

Example `singlevar_dotplot`:

![](../../.gitbook/assets/example\_dot.png)


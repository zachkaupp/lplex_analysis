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

Example `singlevar_dotplot`:

![](../../.gitbook/assets/example\_dot.png)


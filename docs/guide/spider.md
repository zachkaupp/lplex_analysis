# Spider plots

`07-02_spider_plot.R` defines 1 function:

```r
plot_spider <- function(treatment, custom_range = NULL, timepoint_index = 1) {
    # this function returns a spider plot for the specified
    # treatment and timepoint_index. dots on the plot are
    # determined by median, and colored by group
    
    # ARGUMENTS:
    # treatment = str, the name of the treatment in
    #     col_treatment to plot for
    # custom_range = c(double, double), optional argument to
    #     set the range of the plot manually, in the form
    #     c(min, max)
    # timpoint_index = int, the index of the timepoint to
    #     plot for
}
```

Example `spider_plot`:

![](../../.gitbook/assets/example\_spider.png)

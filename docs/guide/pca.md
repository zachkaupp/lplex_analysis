# PCA Plots

`07-03_pca_plot.R` defines 3 functions:

```r
plot_pca <- function(treatment, timepoint_index = 1) {
    # this function returns a pca plot, colored by group,
    # for the specified treatment and timepoint
    
    # ARGUMENTS
    # treatment = str, the name of the treatment in
    #     col_treatment to plot for
    # timepoint_index = int, the index of the timepoint
    #     to plot for
}
```

```r
plot_pca_cluster <- function(grouping = col_treatment, timepoint_index = 1, acc_only = FALSE, avg_acc = NULL, categorical = TRUE) {
    "FUNCTION UNDER DEVELOPMENT"
    
    # this function returns a pca plot, not separated by
    # group, colored by a specified column, and given an
    # accuracy score based on how well the specified column
    # can cluster the data
    
    # ARGUMENTS:
    # grouping = str, the name of the column to color and
    #     cluster by
    # timepoint_index = int, the index of the timepoint to
    #     plot for
    # acc_only = boolean, optional argument to opt to only
    #     return the accuracy score, rather than the whole
    #     plot
    # avg_acc = double, optional argument to set the
    #     accuracy score displayed on the plot
    # categorical = boolean, required argument to specify
    #     whether the column specified in "grouping"
    #     contains categorical or quantitative data. if the
    #     data is quantitative, it will group it into "bins"
    #     in order to make clustering possible
}
```

```r
pca_automatic_clustering <- function(give_rankings = FALSE, timepoint_index = 1) {
    "FUNCTION UNDER DEVELOPMENT"
    
    # this function ranks all the columns in
    # lplex_metadata_columns and col_group in order of their
    # accuracy scores according to plot_pca_cluster, and
    # returns the plot of the one with the highest accuracy
    
    # ARGUMENTS:
    # give_rankings = boolean, optional argument to return
    #     a list of the accuracy score rankings, rather than
    #     returning the final plot
    # timepoint_index = int, the index of the timepoint to
    # cluster and plot for
}
```

Example `pca_plot`:

![](../../.gitbook/assets/example\_pca.png)

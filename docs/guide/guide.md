# Guide

### Output

Many of the scripts in `lplex_analysis` produce output. Output is found in the `output` folder, and is created as the scripts are run.

The scripts usually produce functions that can be called to plot in RStudio, but many of the functions are automatically called in the script to populate the `output` folder, so that the functions do not need to be called individually.

```r
# some scripts have this variable at the top of the file,
# and if it is changed to FALSE, the scripts will not
# automatically export plots to the output folder
save_plots <- TRUE
```

## Plot summaries: (put this into subdocs)

### Violin plot -

* Grouped by timepoint and cytokine
* Violin plot has a set max width
* IQR range layers over violin plots
* Dot plots layered over IQR range
* File Name Format: TIMEPOINT\_CytokineColumn

### Spider plot -

* Grouped by timepoint and treatment
* Dot location determined by median
* Scale is based on log-2-fold-change
* Custom range argument allows graph to plot in a set range, allowing for consistency across graphs
* File Name Format: TIMEPOINT\_TREATMENT

### PCA plot -

* Grouped by timepoint and treatment
* Clustering includes all treatments in order to have enough data for accurate clusters (IN SOME CASES, THIS MAY BE MISLEADING)
* File Name Format: TIMEPOINT\_TREATMENT

### PCA plot clustering -

* plot\_pca\_cluster() function gives option to return only accuracy score or plot the actual data
* pca\_automatic\_clustering() finds the accuracy scores for all the metadata columns and the group column, and plots what it finds to be the most accuracte
* PCA clustering is not separated based on group, except of course, when it clusters based on the group column
* Accuracy Score is an F1 score, multiplied by the number of classes/clusters. That way a clustering with two classes won't average at around 50% as opposed to one with 3 averaging at 30%. Hopefully this way the scores are more comparable.
* PCA clustering does not provide file output

### Singlevar dot plot -

* Outliers calculated so that harshly skewed data can still be shown in an interpretable format
* Outliers are still included in the graph, but at the edge, on the side they would have been off the side of
* Data is shown regardless of GROUP, so now conclusions can be made from these plots, as they are only meant to give a snapshot of the variable distributions

### Heatmap plot -

* Grouped by TIMEPOINT, split by GROUP
* File Name Format: TIMEPOINT
* Scaled by column

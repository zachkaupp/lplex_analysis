# Guide

### Video Tutorials

{% embed url="https://www.youtube.com/playlist?list=PLWbNTbtRBJDA1B32GWftrhAApmZ7ur8Pt" %}

### Output

Many of the scripts in `lplex_analysis` produce output. Output is found in the `output` folder, and is created as the scripts are run.

The scripts usually produce functions that can be called to plot in RStudio, but many of the functions are automatically called in the script to populate the `output` folder, so that the functions do not need to be called individually.

```r
# some scripts have this variable at the top of the file,
# and if it is changed to FALSE, the scripts will not
# automatically export plots to the output folder
save_plots <- TRUE
```

#### Plot Naming

Plot output files are named according to the `timepoint_index`, `_`, then whatever other information defines the graph, such as the analyte column number, or treatment index

## Plot summaries: (put this into subdocs)

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

### Heatmap plot -

* Grouped by TIMEPOINT, split by GROUP
* File Name Format: TIMEPOINT
* Scaled by column

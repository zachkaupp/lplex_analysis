# Guide

## Plot summaries:

### Violin plot -

-   Grouped by timepoint and cytokine
-   Violin plot has a set max width
-   IQR range layers over violin plots
-   Dot plots layered over IQR range
-   File Name Format: TIMEPOINT_CytokineColumn

### Spider plot -

-   Grouped by timepoint and treatment
-   Dot location determined by median
-   Scale is based on log-2-fold-change
-   File Name Format: TIMEPOINT_TREATMENT

### PCA plot -

-   Grouped by timepoint and treatment
-   Clustering includes all treatments in order to have enough data for accurate clusters (IN SOME CASES, THIS MAY BE MISLEADING)
-   File Name Format: TIMEPOINT_TREATMENT

### PCA plot clustering -

- Function gives option to return only F1 accuracy score or plot the actual data, with the option to set the accuracy score from multiple precalculated, averaged scores
- Accuracy Score is an F1 score, multiplied by the number of classes/clusters. That way a clustering with two classes won't average at around 50% as opposed to one with 3 averaging at 30%. Hopefully this way the scores are more comparable.

### Singlevar dot plot -

- Outliers calculated so that harshly skewed data can still be shown in an interpretable format
- Outliers are still included in the graph, but at the edge, on the side they would have been off the side of
- Data is shown regardless of GROUP, so now conclusions can be made from these plots, as they are only meant to give a snapshot of the variable distributions

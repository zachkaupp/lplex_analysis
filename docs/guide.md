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

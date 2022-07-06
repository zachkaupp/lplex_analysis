# Significance Tests

`06_significance_test.R` defines 2 functions:

```r
test_wilcox <- function(treatment = "LPS", timepoint_index = 1) {
    # this function returns a dataframe containing p-values
    # for a 2 sided wilcoxon significance test between
    # the groups defined in "sig_groups" (in settings) for
    # the treatment and timepoint_index specified
    # - this function runs the test on the normalized data
    
    # ARGUMENTS:
    # treatment = str, the treatment (in the treatments
    # column) to run the tests for
    # timepoint_index = int, the timepoint (in the timepoint
    # column) to run the tests for
}
```

```r
test_shapiro <- function(treatment = "LPS", timepoint_index = 1) {
    # this function returns a dataframe containing p-values
    # for a shapiro-wilk normality test for each group
    # for the specified treatment and timepoint_index
    # - this function runs the test on the normalized data
    
    # ARGUMENTS:
    # treatments = str, the treatment (in the treatments
    # column) to run the tests for
    # timepoint_index = int, the timepoint (in the timepoint
    # column to run the tests for
}
```

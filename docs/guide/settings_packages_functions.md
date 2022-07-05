# Settings, Packages, and Functions

### Settings

`00_settings.R` contains settings that need to be changed according to the data being processed.

#### Required

Settings that are required to be changed (as marked in the file) include:

* Column names
* Column Indexes
* Values

Column names:

```r
col_id <- "" # set this variable to the name of the column
# that contains unique identifiers for the different
# participants represented in the data. Each ID can have
# multiple treatments associated with it, as well as
# multiple timepoints, but it must be associated with a 
# row of negative control data
col_group <- "" # set this variable to the name of the
# column that contatins the groups in the study:
# experimental, control, etc.
col_treatment <- "" # set this variable to the name of the
# column that contains the different treatments, or stims,
# that a sample may have undergone
col_timepoint <- "" # set this variable to the name of the
# column that contains the approximate time each sample was
# taken. This can only be categorical, and a more exact
# time can only be in a separate column. e.g. timepoints 1
# and 2, as opposed to 8 AM July 4, and 9 PM July 7
```

Column Indexes:

```r
lplex_data_columns <- c() # set this to the indexes, or
# column numbers of the analytes being measured in
# the study. Indexes start at 1 in R, so if the only analyte
# measured was saved in column number 6, the value saved to
# this variable should be c(6)
lplex_metadata_columns <- c() # set this to the indexes, or
# column numbers of the metadata saved about participants.
# this could include age, time of the sample, etc.
# these column indexes are used for clustering
```

Values:

```r
sig_groups <- c() # set this to the names of the two groups
# (in the col_group column) you would like to have the
# Wilcoxon and Shapiro-Wilk statistical tests run with
control <- "" # set this to the treatment in col_treatment
# that should be considered the negative control for data
# normalization
```

#### Optional

```r
excluded_timepoints <- c() # rows with a value contained
# here in their col_timepoint will be excluded
excluded_groups <- c() # rows with a value contained here
# in their col_group will be excluded
export_format <- "png" # support for alternate export
# formats is not guaranteed, but the export format of the
# plots can be changed here
possible_na_values <- c() # these contain any recognized
# ways that missing data will be marked. if missing data
# is not excluded correctly, the way it was saved can be
# added to this vector so it is removed in the future
outlier_crit <- 4.5 # this adjusts the formula for
# calculating outliers as it is determined in this program.
# the formula is (outlier_crit * iqr) +/- median
```

### Packages

`01_packages.R` imports all the packages that the following files may need

### Functions

`02_functions.R` defines functions that following files may need including:

* `normalize()` used to normalize data with log 2 fold change
* `average_repeats()` used to take the median of any repeat treatments in its `input_tibble` and return a tibble with only unique treatments

## SETTINGS (must be in all caps)

# COLUMN NAMES (required) ---

col_id <- "ID"
col_group <- "GROUP"
col_treatment <- "STIM" 
col_timepoint <- "TIMEPOINT"

# COLUMN INDEXES (required) ---

lplex_data_columns <- c(5:9) # cytokine measurements e.g. c(46, 47, 49, 54)
lplex_metadata_columns <- c() # demographic data for clustering

# VALUES (required) ---

sig_groups <- c("A", "B") # 2 groups to compare in significance tests, e.g. c("A", "B")
limit_detection <- c(rep(0, length(lplex_data_columns))) # limit of detection for each data column, must match the length of lplex_data_columns
control <- "NIL" # negative control for data normalization

# SPECIAL SETTINGS (optional) ---

excluded_timepoints <- c("#N/A", "N/A", "NA") # if you remove this, it can't filter
# the N/A properly for some reason
excluded_groups <- c("#N/A", "N/A", "NA")
export_format <- "png" # Mac Preview allows multiple PNGs to be opened at
# a time, unlike with PDF
possible_na_values <- c("NA", "N/A", "#N/A", "#NAME?")
outlier_crit <- 4.5 # criteria for outliers - formula is (outlier_crit * iqr) +/- median
do_normalize <- TRUE # determines whether or not normalization is performed

cat("Settings saved")

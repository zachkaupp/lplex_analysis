## SETTINGS (must be in all caps)

# COLUMN NAMES ---

col_id <- "ID"
col_group <- "GROUP"
col_treatment <- "STIM" 
col_timepoint <- "TIMEPOINT"

# COLUMN INDEXES (indices start at 1)

lplex_data_columns <- c(6:18) # cytokine measurements
lplex_metadata_columns <- c() # demographic data for clustering

# VALUE NAMES ---

control <- "NIL" # negative control for data normalization

# SPECIAL SETTINGS ---

excluded_timepoints <- c("#N/A", "N/A", "NA") # if you remove this, it can't filter
# the N/A properly for some reason
excluded_groups <- c("#N/A", "N/A", "NA")
export_format <- "png" # Mac Preview allows multiple PNGs to be opened at
# a time, unlike with PDF
possible_na_values <- c("NA", "N/A", "#N/A", "#NAME?")

cat("Settings saved")

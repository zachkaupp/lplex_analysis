## SETTINGS (must be in all caps)

# COLUMN NAMES ---

col_id <- "ID"
col_group <- "GROUP"
col_treatment <- "STIM" 
col_timepoint <- "TIMEPOINT"

# VALUE NAMES ---

control <- "NIL" # negative control for data normalization

# SPECIAL SETTINGS ---

excluded_timepoints <- c("N/A") # if you remove this, it can't filter
# the N/A properly for some reason
excluded_groups <- c("#N/A", "N/A")

# necessary columns:
# - STIM
# - GROUP
# - TIMEPOINT
# - ID
# - cytokines?

print("Process complete")

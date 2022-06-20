## Find the data, clean it, and normalize it

# SETTINGS ---

excluded_timepoints <- c("N/A") # if you remove this, it can't filter
# the N/A properly for some reason
excluded_groups <- c("#N/A", "N/A")

# necessary columns:
# - STIM
# - GROUP
# - TIMEPOINT
# - ID
# - cytokines?

# FIND THE FILE LOCATION ---
print("NOTE: ONLY CSV FILES ACCEPTED")
if (length(list.files(path = "data")) == 0) {
  stop("There are no files in the 'data' directory. Place a .csv file 
       in the 'data' directory and try again.")
}

file_location = paste("data/", list.files(path = "data"), collapse = NULL, sep = "")
print(paste("File found: ", file_location))

if (length(file_location) > 1) {
  file_location <- file_location[as.integer(readline("Enter the index of the correct file: "))]
  print(paste("Selected: ", file_location))
}

# READ THE FILE ---

lplex <- read_csv(file_location, show_col_types = FALSE)

# CLEAN THE DATAFRAME ---

# Make everything uppercase so it isn't case sensitive
for (i in 1:length(lplex)) {
  for (j in 1:nrow(lplex[,i])) {
    if (typeof(lplex[[j,i]]) == "character") {
      lplex[j,i] <- toupper(lplex[j,i])
    }
  }
}

# SEPARATE AND PRUNE THE DATAFRAME ---

# separate by ID
lplex_list <- split(lplex, f = lplex$ID)

# expand list out by TIMEPOINT, so every ID x TIMEPOINT
# combination is a dataframe in a list
lplex_list_expanded = list()
added <- 0
for (i in lplex_list) {
  x <- split(i, i$TIMEPOINT)
  for (j in x) {
    lplex_list_expanded[[added + 1]] <- j
    added <- added + 1
  }
}

# deal with dataframes that have no nil or have retakes
lplex_list_filtered <- list()
lplex_list_no_nil <- list()
lplex_list_repeats <- list()
added <- 0
no_nil <- 0
repeats <- 0

for (i in lplex_list_expanded) {
  if (!("NIL" %in% i$STIM)) { # this checks if it is missing a NIL
    lplex_list_no_nil[[no_nil + 1]] <- i
    no_nil <- no_nil + 1
  } else if (length(i$STIM) > length(levels(factor(x = i$STIM)))) { # this checks if there are repeat STIMs
    lplex_list_repeats[[repeats + 1]] <- i
    repeats <- repeats + 1
  } else { # otherwise, the data is good
    lplex_list_filtered[[added + 1]] <- i
    added <- added + 1
  }
}

# combine the data that isn't good into dataframes
lplex_no_nil <- bind_rows(lplex_list_no_nil)
lplex_repeats <- bind_rows(lplex_list_repeats)

# update the user on the filtering process
print(paste("Sets with no NIL: ", no_nil))
print(paste("Sets with repeat STIMs: ", repeats))
print(paste("Total removed: ", no_nil + repeats))
print(paste("Sets remaining: ",length(lplex_list_filtered)))

# NORMALIZE THE DATA AND MERGE ---

x <- list()
for (i in 1:length(lplex_list_filtered)) {
  x[[i]] <- normalize(lplex_list_filtered[[i]])
}
lplex_normal <- bind_rows(x)

# REMOVE GROUPS ---
lplex_normal <- lplex_normal %>%
  filter(!(GROUP %in% excluded_groups))

# SEPARATE DATAFRAME BASED ON TIMEPOINTS ---

lplex_normal_list_timepoints <- list()
timepoints <- levels(factor(lplex$TIMEPOINT))

added <- 0
for (i in timepoints) {
  if (i %in% excluded_timepoints) {
    next
  }
  lplex_normal_list_timepoints[[added + 1]] <- filter(lplex_normal, TIMEPOINT == i)
  added <- added + 1
}

## FIND WHICH COLUMNS HAVE DATA ---

lplex_data_columns <- c() # these are the indices for the columns that have cytokine data
for (i in 1:length(lplex_normal)) {
  if (typeof(lplex_normal[[i]]) == "double") {
    lplex_data_columns <- c(lplex_data_columns, i)
  }
}

## FIND A LIST OF THE STIMS ---

lplex_stims <- levels(factor(lplex_normal$STIM))

## OUTPUT ---

write_csv(lplex_no_nil, "output/filtered_data/no_nil.csv")
write_csv(lplex_repeats, "output/filtered_data/repeats.csv")
write_csv(lplex_normal, "output/filtered_data/normalized.csv")

## REMOVE UNNECESSARY VARIABLES ---

rm(lplex, lplex_list, lplex_list_expanded, lplex_list_filtered,
            lplex_list_no_nil, lplex_list_repeats, lplex_no_nil,
            lplex_repeats, j, x) # dataframes

rm(added, i, file_location, no_nil, repeats, timepoints) # values

print("Process complete")

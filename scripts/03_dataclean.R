## Find the data, clean it, and normalize it

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

lplex <- read_csv(file_location,
                  show_col_types = TRUE,
                  col_types = strrep("c", 50))
for (i in 1:length(lplex)) {
  if (i %in% lplex_data_columns) {
    lplex[[i]] <- parse_number(lplex[[i]])
  }
}

# CLEAN THE DATAFRAME ---

# Make everything uppercase so it isn't case sensitive
for (i in 1:length(lplex)) {
  for (j in 1:nrow(lplex[,i])) {
    if (typeof(lplex[[j,i]]) == "character") {
      lplex[j,i] <- toupper(lplex[j,i])
    }
  }
}
colnames(lplex) <- toupper(colnames(lplex)) # this does the same thing for column names

## FIND WHICH COLUMNS HAVE DATA ---
if (length(lplex_data_columns) == 0) {
  cat(yellow("lplex_data_columns is empty, attempting to find it automatically\n"))
  lplex_data_columns <- c() # these are the indices for the columns that have cytokine data
  for (i in 1:length(lplex)) {
    if (typeof(lplex[[i]]) == "double") {
      lplex_data_columns <- c(lplex_data_columns, i)
    }
  }
}

# SEPARATE AND PRUNE THE DATAFRAME ---

# separate by ID
lplex_list <- split(lplex, f = lplex[[col_id]])

# expand list out by TIMEPOINT, so every ID x TIMEPOINT
# combination is a dataframe in a list
lplex_list_expanded = list()
added <- 0
for (i in lplex_list) {
  x <- split(i, i[[col_timepoint]])
  for (j in x) {
    lplex_list_expanded[[added + 1]] <- j
    added <- added + 1
  }
}

# deal with dataframes that have no control or have retakes
lplex_list_filtered <- list()
lplex_list_no_control <- list()
lplex_list_repeats <- list()
added <- 0
no_control <- 0
repeats <- 0

for (i in lplex_list_expanded) {
  if (!(control %in% i[[col_treatment]])) { # this checks if it is missing a control
    lplex_list_no_control[[no_control + 1]] <- i
    no_control <- no_control + 1
  } else if (length(i[[col_treatment]]) > length(levels(factor(x = i[[col_treatment]])))) { # this checks if there are repeat treatments
    lplex_list_repeats[[repeats + 1]] <- i
    repeats <- repeats + 1
  } else { # otherwise, the data is good
    lplex_list_filtered[[added + 1]] <- i
    added <- added + 1
  }
}

# combine the data that isn't good into dataframes
lplex_no_control <- bind_rows(lplex_list_no_control)
lplex_repeats <- bind_rows(lplex_list_repeats)

# update the user on the filtering process
print(paste("Sets with no control: ", no_control))
print(paste("Sets with repeat treatments: ", repeats))
print(paste("Total removed: ", no_control + repeats))
print(paste("Sets remaining: ",length(lplex_list_filtered)))

# NORMALIZE THE DATA AND MERGE ---

x <- list()
for (i in 1:length(lplex_list_filtered)) {
  x[[i]] <- normalize(lplex_list_filtered[[i]], control)
}
lplex_normal <- bind_rows(x)

# REMOVE GROUPS ---
lplex_normal <- lplex_normal %>%
  filter(!(!!sym(col_group) %in% excluded_groups))

# SEPARATE DATAFRAME BASED ON TIMEPOINTS ---

lplex_normal_list_timepoints <- list()
timepoints <- levels(factor(lplex[[col_timepoint]]))

added <- 0
for (i in timepoints) {
  if (i %in% excluded_timepoints) {
    next
  }
  lplex_normal_list_timepoints[[added + 1]] <- filter(lplex_normal, !!sym(col_timepoint) == i)
  added <- added + 1
}

## FIND A LIST OF THE TREATMENTS ---

lplex_treatments <- levels(factor(lplex_normal[[col_treatment]]))

## OUTPUT ---

write_csv(lplex_no_control, "output/filtered_data/no_control.csv")
write_csv(lplex_repeats, "output/filtered_data/repeats.csv")
write_csv(lplex_normal, "output/filtered_data/normalized.csv")

## REMOVE UNNECESSARY VARIABLES ---

rm(lplex_list, lplex_list_expanded, lplex_list_filtered,
            lplex_list_no_control, lplex_list_repeats, lplex_no_control,
            lplex_repeats, j, x) # dataframes

rm(added, i, file_location, no_control, repeats, timepoints) # values

print("Process complete")

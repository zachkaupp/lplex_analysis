## Find the data, clean it, and normalize it

# STANDARDIZE COL_NAMES AND VALUES--- 
col_id <- sub(" ", "_", toupper(col_id))
col_group <- sub(" ", "_", toupper(col_group))
col_treatment <- sub(" ", "_", toupper(col_treatment))
col_timepoint <- sub(" ", "_", toupper(col_timepoint))
control <- sub(" ", "_", toupper(control))

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
suppressWarnings( # because it will warn that it is saving some values as NA
  lplex <- read_csv(file_location,
                    show_col_types = FALSE,
                    col_types = strrep("c", 99999)) # this is a bad way of making sure everything is read as a character
)

# CLEAN THE DATAFRAME ---

# take spaces and newlines out of column names
colnames(lplex) <- sub(" ", "_", colnames(lplex))

# Make everything uppercase so it isn't case sensitive
for (i in 1:length(lplex)) {
  for (j in 1:nrow(lplex[,i])) {
    if (typeof(lplex[[j,i]]) == "character") {
      lplex[j,i] <- toupper(lplex[j,i])
    }
  }
}
colnames(lplex) <- toupper(colnames(lplex)) # this does the same thing for column names

# get rid of rows with NA values in the necessary columns
x <- nrow(lplex)
y <- lplex
lplex <- lplex %>%
  drop_na(!!sym(col_id), # this will take out NA values created by R
          !!sym(col_group),
          !!sym(col_treatment),
          !!sym(col_timepoint),
          all_of(lplex_data_columns))
for (i in append(list(col_id, col_group, col_treatment, col_timepoint),
                 lplex_data_columns)) { # this will take out NA values created by Excel
  if (typeof(i) == "character") { # if it is a column name
    lplex <- lplex %>%
      filter(!(!!sym(i) %in% possible_na_values))
  } else if (typeof(i) == "integer" | typeof(i) == "double") { # if it is a column index
    lplex <- lplex %>%
      filter(!(!!sym(colnames(lplex)[i]) %in% possible_na_values))
  }
}
na_rows <- x - nrow(lplex)
lplex_na <- setdiff(y, lplex)

# change the data columns to number variables
for (i in 1:length(lplex)) {
  if (i %in% lplex_data_columns) {
    lplex[[i]] <- parse_number(lplex[[i]])
  }
}

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

## FIND A LIST OF THE TREATMENTS ---

lplex_treatments <- levels(factor(lplex[[col_treatment]])) # get all the treatments
if (do_normalize) {
  lplex_treatments <- lplex_treatments[!lplex_treatments %in% control] # take out the control treatment
}

## APPLY LIMIT OF DETECTION ---

for (i in 1:length(lplex_data_columns)) {
  x <- lplex[[lplex_data_columns[[i]]]]
  for (j in 1:length(x)) {
    if (x[[j]] < limit_detection[[i]]) {
      x[[j]] <- limit_detection[[i]]
    }
  }
  lplex[[lplex_data_columns[[i]]]] <- x
}
# go through each data_column, save it to a vector,
# for each value in the vector, check if it is above and set it
# if it isn't, save the vector back to lplex

## SEPARATE AND PRUNE THE DATAFRAME ---

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
    lplex_list_filtered[[added + 1]] <- average_repeats(i,
                                                        lplex_treatments,
                                                        lplex_data_columns)
    repeats <- repeats + 1
    added <- added + 1
  } else { # otherwise, the data is good
    lplex_list_filtered[[added + 1]] <- i
    added <- added + 1
  }
}

# combine the data that isn't good into dataframes
lplex_no_control <- bind_rows(lplex_list_no_control)
lplex_repeats <- bind_rows(lplex_list_repeats)

# update the user on the filtering process
print(paste("Rows with NA in necessary columns: ", na_rows))
print(paste("Sets with no control: ", no_control))
print(paste("Total removed (sets or rows): ", no_control + na_rows))
print(paste("Sets with repeat treatments: ", repeats))
print(paste("Total averaged (by median): ", repeats))
print(paste("Sets remaining: ",length(lplex_list_filtered)))

# NORMALIZE THE DATA AND MERGE ---

x <- list()
for (i in 1:length(lplex_list_filtered)) {
  if (do_normalize) {
    x[[i]] <- normalize(lplex_list_filtered[[i]], control)
  } else {
    x[[i]] <- lplex_list_filtered[[i]]
  }
  
}
lplex_normal <- bind_rows(x)

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

## OUTPUT ---

do.call(file.remove, list(list.files("output/filtered_data/", full.names = TRUE))) # removes old files
write_csv(lplex_no_control, "output/filtered_data/no_control.csv")
write_csv(lplex_repeats, "output/filtered_data/repeats.csv")
write_csv(lplex_normal, "output/filtered_data/normalized.csv")
write_csv(lplex_na, "output/filtered_data/na.csv")

## REMOVE UNNECESSARY VARIABLES ---

rm(lplex_list, lplex_list_expanded, lplex_list_filtered,
            lplex_list_no_control, lplex_list_repeats, lplex_no_control,
            lplex_repeats, j, x, y, lplex_na) # dataframes

rm(added, i, file_location, no_control, repeats, timepoints, na_rows) # values

cat(yellow("From now on, column names are in ALL CAPS, and spaces are replaced with \"_\"\n"))

cat(cyan("Process complete\n"))

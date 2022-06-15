## Find the data, clean it, and normalize it

# SETTINGS ---

excluded_timepoints <- c("N/A") # if remove this, it can't filter
# the N/A properly for some reason
excluded_groups <- c("#N/A", "N/A")

# FIND THE FILE LOCATION ---
print("NOTE: ONLY CSV FILES ACCEPTED")
if (length(list.files(path = "data")) == 0) {
  stop("There are no files in the 'data' directory")
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

lplex_list <- split(lplex, f = lplex$ID)

# expand list out by timepoints, so every ID x TIMEPOINT
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

# deal with dataframes that have no nil or retakes
lplex_list_filtered <- list()
added <- 0
no_nil <- 0
repeats <- 0
for (i in lplex_list_expanded) {
  if (!("NIL" %in% i$STIM)) { #this checks if it is missing a NIL
    no_nil <- no_nil + 1
    #print(i) # to print sets with no nil
  } else if (length(i$STIM) > length(levels(factor(x = i$STIM)))) { #this checks if there are repeat STIMs
    repeats <- repeats + 1
    print(i) # to print sets with repeats
  } else {
    lplex_list_filtered[[added + 1]] <- i
    added <- added + 1
  }
}
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

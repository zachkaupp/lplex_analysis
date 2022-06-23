## Initialize necessary functions

## NORMALIZE ---

# this normalizes to the control with log-2-fold-change
normalize <- function(input_tibble, denominator) {
  y <- input_tibble %>% # 1 row tibble with control values
    filter(!!sym(col_treatment) == denominator)
  z <- input_tibble %>% # tibble with all the other values
    filter(!(!!sym(col_treatment) == denominator))
  if (nrow(z) == 0) {
    return(z)
  }
  normal <- input_tibble %>%
    filter(!(!!sym(col_treatment) == denominator))
  for (i in 1:length(z)) {
    for (j in 1:nrow(z[,i])) {
      if (i %in% lplex_data_columns) {
        normal[j,i] <- log((z[j,i] / y[1,i]), 2)
      }
    }
  }
  return(normal)
}

## AVERAGE REPEATS ---

# this takes an ID x TIMEPOINT combination from dataclean,
# and takes the median of any repeats, returning a table
# with only unique treatments
average_repeats <- function(input_tibble, treatments, data_columns) {
  list_by_treatments <- list() # holds the rows grouped by treatment
  added <- 0
  for (i in c(treatments, control)) {
    x <- input_tibble %>%
      filter(!!sym(col_treatment) == i)
    if (nrow(x) != 0) {
      list_by_treatments[[added + 1]] <- x
      added <- added + 1
    }
  }
  list_averaged <- list()
  added <- 0
  for (i in list_by_treatments) {
    x <- i[1,]
    for (j in data_columns) {
      x[[1,j]] <- median(i[[j]])
    }
    list_averaged[[added + 1]] <- x
    added <- added + 1
  }
  return(bind_rows(list_averaged))
}

cat(cyan("Process complete"))

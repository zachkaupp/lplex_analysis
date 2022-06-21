## Initialize necessary functions

# NORMALIZE ---

# this normalizes to the control with log-2-fold-change
normalize <- function(input_tibble, denominator) {
  y <- input_tibble %>%
    filter(!!sym(col_treatment) == denominator)
  z <- input_tibble %>%
    filter(!(!!sym(col_treatment) == denominator))
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

print("Process complete")

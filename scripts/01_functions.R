## Initialize necessary functions

# NORMALIZE ---

# this normalizes to the control with log-2-fold-change
normalize <- function(input_tibble, denominator) {
  y <- input_tibble %>%
    filter(STIM == denominator)
  z <- input_tibble %>%
    filter(!(STIM == denominator))
  normal <- input_tibble %>%
    filter(!(STIM == denominator))
  for (i in 1:length(z)) {
    for (j in 1:nrow(z[,i])) {
      if (typeof(z[[j,i]]) == "double") {
        normal[j,i] <- log((z[j,i] / y[1,i]), 2)
      }
    }
  }
  return(normal)
}

print("Process complete")

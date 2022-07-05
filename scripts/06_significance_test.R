## Record p-values for each analyte between groups

# perform a wilcox test between the two groups
test_wilcox <- function(treatment = "LPS", timepoint_index = 1) {
  
  if (length(sig_groups) != 2) {
    stop("sig_groups must have 2 values to use the wilcox test")
  }
  
  test_list <- list()
  added <- 0
  df <- lplex_normal %>%
    filter(!!sym(col_timepoint) == levels(factor(lplex_normal_list_timepoints[[timepoint_index]][[col_timepoint]]))) %>%
    filter(!!sym(col_treatment) == treatment)
  group1 <- df %>%
    filter(!!sym(col_group) == sig_groups[[1]])
  group2 <- df %>%
    filter(!!sym(col_group) == sig_groups[[2]])
  
  for (i in lplex_data_columns) {
    x <- group1[[i]]
    y <- group2[[i]]
    
    warn <- "none"
    warn_or_error_check <- tryCatch(wilcox.test(x,y)$p.value, error=function(e) e,warning=function(w) w)
    if (is(warn_or_error_check, "error")) {
      cat(yellow(paste("Excluded TIMEPOINT: ", levels(factor(lplex_normal_list_timepoints[[timepoint_index]][[col_timepoint]])),
                    ", TREATMENT: ", treatment,
                    ", ANALYTE: ", colnames(lplex)[[i]],
                    " -- ", warn_or_error_check,
                    sep = "")))
      p <- -1 # p value can't be calculated
    } else if (is(warn_or_error_check, "warning")) {
      suppressWarnings(
        p <- round(wilcox.test(x,y)$p.value, 10)
      )
      warn <- as.character(warn_or_error_check)
    } else {
      p <- round(wilcox.test(x,y)$p.value, 10)
    }
    
    test_row <- data.frame( # save the data to a dataframe with a single row
      "TIMEPOINT" = levels(factor(lplex_normal_list_timepoints[[timepoint_index]][[col_timepoint]])),
      "TREATMENT" = treatment,
      "ANALYTE" = colnames(lplex)[[i]],
      "p" = p,
      "WARNING" = warn
    )
    test_list[[added + 1]] <- test_row # add row to list of rows
    added <- added + 1
  }
  
  return(bind_rows(test_list)) # return full dataframe of p-values at this timepoint x treatment combination
}

# perform a shapiro wilk test (code originally copied from wilkcox, very similar)
test_shapiro <- function(treatment = "LPS", timepoint_index = 1) {
  
  if (length(sig_groups) == 0) {
    stop("sig_groups must have 1 or more values to use the shapiro test")
  }
  
  test_list <- list()
  added <- 0
  df <- lplex_normal %>%
    filter(!!sym(col_timepoint) == levels(factor(lplex_normal_list_timepoints[[timepoint_index]][[col_timepoint]]))) %>%
    filter(!!sym(col_treatment) == treatment)
  test_groups <- list()
  for (i in sig_groups) {
    test_groups[[length(test_groups) + 1]] <- df %>%
      filter(!!sym(col_group) == i)
  }
  
  for (i in lplex_data_columns) {
    for (j in test_groups) {
      test_group <- levels(factor(j[[col_group]]))
      warn <- "none"
      warn_or_error_check <- tryCatch(shapiro.test(j[[i]])$p.value, error=function(e) e,warning=function(w) w)
      if (is(warn_or_error_check, "error")) {
        cat(yellow(paste("Excluded TIMEPOINT: ", levels(factor(lplex_normal_list_timepoints[[timepoint_index]][[col_timepoint]])),
                      ", TREATMENT: ", treatment,
                      ", ANALYTE: ", colnames(lplex)[[i]],
                      ", GROUP: ", levels(factor(j[[col_group]])),
                      " -- ", warn_or_error_check,
                      sep = "")))
        p <- -1 # p value can't be calculated
        test_group <- "?" # group also can't be calculated
      } else if (is(warn_or_error_check, "warning")) {
        suppressWarnings(
          p <- round(shapiro.test(j[[i]])$p.value, 10)
        )
        warn <- as.character(warn_or_error_check)
      } else {
        p <- round(shapiro.test(j[[i]])$p.value, 10)
      }
      test_row <- data.frame( # save the data to a dataframe with a single row
        "TIMEPOINT" = levels(factor(lplex_normal_list_timepoints[[timepoint_index]][[col_timepoint]])),
        "TREATMENT" = treatment,
        "ANALYTE" = colnames(lplex)[[i]],
        "GROUP" = test_group,
        "p" = p,
        "WARNING" = warn
      )
      test_list[[added + 1]] <- test_row # add row to list of rows
      added <- added + 1
    }
  }
  
  return(bind_rows(test_list)) # return full dataframe of p-values at this timepoint x treatment combination
}

## OUTPUT ---

# wilcox
x <- list()
added <- 0
for (i in 1:length(lplex_normal_list_timepoints)) {
  for (j in lplex_treatments) {
    x[[added + 1]] <- test_wilcox(treatment = j, timepoint_index = i)
    added <- added + 1
  }
}
final_df_wilcox <- bind_rows(x)
write_csv(final_df_wilcox, "output/filtered_data/wilcox_test.csv")

# shapiro
x <- list()
added <- 0
for (i in 1:length(lplex_normal_list_timepoints)) {
  for (j in lplex_treatments) {
    x[[added + 1]] <- test_shapiro(treatment = j, timepoint_index = i)
    added <- added + 1
  }
}
final_df_shapiro <- bind_rows(x)
write_csv(final_df_shapiro, "output/filtered_data/shapiro_test.csv")

rm(x, added, i, j, final_df_wilcox, final_df_shapiro)

print(paste("Groups Used: ", sig_groups[[1]], ", ", sig_groups[[2]], sep = ""))

cat(cyan("Process complete\n"))

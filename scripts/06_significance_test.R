## Record p-values for each analyte between groups

sig_groups <- c("A", "B") # 2 groups to compare in significance tests

# perform a wilcox test between the two groups
test_wilcox <- function(treatment = "NIL", timepoint_index = 1) {
  test_list <- list()
  added <- 0
  df <- lplex %>%
    filter(!!sym(col_timepoint) == levels(factor(lplex_normal_list_timepoints[[timepoint_index]][[col_timepoint]]))) %>%
    filter(!!sym(col_treatment) == treatment)
  group1 <- df %>%
    filter(!!sym(col_group) == sig_groups[[1]])
  group2 <- df %>%
    filter(!!sym(col_group) == sig_groups[[2]])
  
  for (i in lplex_data_columns) {
    x <- group1[[i]]
    y <- group2[[i]]
    
    warn <- NULL
    tryCatch(
      expr = {
        p <- wilcox.test(x,y)$p.value # get the p-value and check for ties warning
      },
      warning = function(w) {
        warn <- as.character(w)
        if (warn == "simpleWarning in wilcox.test.default(x, y): cannot compute exact p-value with ties\n") {
          cat(yellow(paste("Warning: p-value inexact because of ties for", colnames(lplex)[[i]], "\n")))
        }
      },
      finally = {
        suppressWarnings(
          p <- wilcox.test(x,y)$p.value # in case the warning prevented it from running
        )
      }
    )
    
    test_row <- data.frame(
      "TIMEPOINT" = levels(factor(lplex_normal_list_timepoints[[timepoint_index]][[col_timepoint]])),
      "TREATMENT" = treatment,
      "ANALYTE" = colnames(lplex)[[i]],
      "p" = p
    )
    test_list[[added + 1]] <- test_row
    added <- added + 1
  }
  #View(bind_rows(test_list))
  print(paste("Groups Used: ", sig_groups[[1]], ", ", sig_groups[[2]], sep = ""))
}

cat(cyan("Process complete\n"))

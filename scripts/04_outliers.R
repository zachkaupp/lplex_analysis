## Find significant outliers in the data and output them

outliers <- list()
added <- 0

for (i in lplex_data_columns) {
  x <- lplex[[i]] # one data column of lplex
  iqr <- IQR(x)
  med <- median(x)
  for (j in 1:length(x)) {
    if ((x[[j]] > (med + (outlier_crit * iqr))) | (x[[j]] < (med - (outlier_crit * iqr)))) {
      outlier_row <- lplex[j,] # 1 tibble row with outlier
      df_row <- data.frame(one = outlier_row[[1, col_id]], # format the row correctly
                           two = outlier_row[[1, col_treatment]],
                           three = outlier_row[[1, col_group]],
                           four = outlier_row[[1, col_timepoint]],
                           five = colnames(lplex)[[i]],
                           six = x[[j]])
      names(df_row) <- c(col_id, # set the names of the formatted row
                         col_treatment,
                         col_group, col_timepoint,
                         "ANALYTE",
                         "VALUE")
      outliers[[added + 1]] <- df_row
      added <- added + 1
    }
  }
}
outliers_df <- bind_rows(outliers) # put the list of rows into one dataframe

## OUTPUT ---

write_csv(outliers_df, "output/filtered_data/outliers.csv")

## REMOVE UNNECESSARY VARIABLES ---

suppressWarnings(rm(df_row, outlier_row, outliers, added, i, iqr, j, med, x))

cat(cyan("Process complete\n"))

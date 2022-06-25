## Find significant outliers in the data and output them

local(
  for (i in lplex_data_columns) {
    iqr <- IQR(lplex[[i]])
    x <- lplex[[i]]
    med <- median(x)
    for (j in 1:length(x)) {
      if ((x[[j]] > (med + (outlier_crit * iqr))) | (x[[j]] < (med - (outlier_crit * iqr)))) {
        print(lplex[j,]) # 1 tibble row with outlier
        # TODO select the necessary columns, analyte column is dynamic per iteration
        # tidy format the row so analyte has a column
        # create empty dataframe and bind the created row on each iteration
      }
    }
  }
)

# output format:
# columns: id, stim, group, timepoint, analyte/cytokine, outlier value

cat(cyan("Process complete\n"))

## Find significant outliers in the data and output them

local(
  for (i in lplex_data_columns) {
    iqr <- IQR(lplex[[i]])
    x <- lplex[[i]]
    med <- median(x)
    for (j in 1:length(x)) {
      if ((x[[j]] > (med + (outlier_crit * iqr))) | (x[[j]] < (med - (outlier_crit * iqr)))) {
        print(j)
      }
    }
  }
)

cat(cyan("Process complete\n"))

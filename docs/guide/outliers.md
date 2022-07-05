# Outliers

`04_outliers.R` is fully automatic.

This script will create `output/filtered_data/outliers.csv` to record all the outliers in the pre-normalized data

Outlier criteria: (`outlier_crit` \* iqr) +/- median

One analyte column from `lplex_data_columns` is selected at a time, and outliers are determined from that column, regardless of `group`, `timepoint`, or any other variables.

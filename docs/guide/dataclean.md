# Dataclean

### Manual input

The only part of `03_dataclean.R` that requires input is the file selection. If there is more than one `.csv` in the `data` folder, it will require input to specify the selection of the file to use.

### General Structure

* Find the file and read it
* Standardize the data
  * Take out NA values
  * Make everything UPPERCASE
  * Take out spaces, and replace them with "\_"
  * Change data columns to numbers, and keep all other columns as characters
* Separate the data
  * Separate the data into sets for every ID x TIMEPOINT combination for normalizing and filtering
* Normalize and filter the data
  * Take out sets that have no negative control treatment
  * Take the average of repeat treatments in a set
  * Normalize the data according to log 2 fold change -- log (treatment/negative control), base 2
* Recombine the data, and give output
  * Combine the data into one dataframe, as well as a list of dataframes separated by TIMEPOINT
  * Output the sets with na values, no negative control, repeat treatments, and output the normalized data

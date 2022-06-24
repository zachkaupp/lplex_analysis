# Quick Start

## Formatting Data

First, make sure that the input data has these required columns
| ID                         | GROUP                                          | TREATMENT | TIMEPOINT                                                                                   |
|---------------|---------------|---------------|---------------------------|
| Participant Identification | Group (experimental, control, etc.) Identifier | Stim      | In studies without a timepoint, create a TIMEPOINT column and fill it with a constant value |
- The names of the columns can be different than the ones shown here, but the data has to be present

With the data:
1. Export it as a .csv
2. Place your .csv into the `data` folder of this repository

## Set up RStudio

1. Open `lplex_analysis.Rproj` from this repository in RStudio
2. Install the required packages if you don't have them using the following commands in the R console of RStudio:
```R
# These may take a while to download

# Run this first
install.packages(c("tidyverse", "tibble", "scales", "ggfortify", "devtools", "cluster", "crayon", "glue"))

# Run this second
library(devtools)

# Run this third
devtools::install_github("ricardo-bion/ggradar", dependencies = TRUE)
```

## Set the Settings

- In the file pane of RStudio, open `scripts`, and then open `00_settings.R
- Set the required column names to the way the columns are named in your data
- Set `lplex_data_columns` to the indexes for your data/cytokine columns
```R
# This can be done a couple of ways:
c(3:6) # = columns 3, 4, 5, and 6
c(3, 4, 5, 6) # = columns 3, 4, 5, and 6
```

## Run the Scripts

- Run the files in the `scripts` folder of this repository in the order they are numbered with 'source' in the editor pane of RStudio (Dont forget `00_settings.R`!)

## Find the output

- Data is exported by the project into the `output` folder of this repository
- `filtered_data` contains .csv files with cleaned data
- `plot_x` folders contain the different plots, and their numbering scheme can be found in the guide

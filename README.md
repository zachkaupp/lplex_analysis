# lplex_analysis (work in progress)

This project provides graphical information about legendplex data

## Required Columns:
| ID                         | GROUP                                          | TREATMENT | TIMEPOINT                                                                                   |
|----------------------------|------------------------------------------------|-----------|---------------------------------------------------------------------------------------------|
| Participant Identification | Group (experimental, control, etc.) Identifier | Stim      | In studies without a timepoint, create a TIMEPOINT column and fill it with a constant value |

## To Use:

- Clone this repository:
```
git clone https://github.com/zachkaupp/lplex_analysis.git
```

- Export legendplex data as a .csv, and put it in the `data` directory

- Open `lplex_analysis.Rproj` in RStudio

- Install the required packages, if you don't have them
```r
# Run these in the R console to install
# all the necessary packages

install.packages(c("tidyverse", "tibble", "scales", "ggfortify", "devtools", "cluster", "crayon", "glue"))

library(devtools)
devtools::install_github("ricardo-bion/ggradar", dependencies = TRUE)
```

- Run R scripts from the `scripts` file in the order they are numbered

- Find output plots in the `output` directory

### Walkthrough (outdated, but generally correct):
[![lplex_walkthrough](http://img.youtube.com/vi/Aqx3z4Fg1aw/0.jpg)](http://www.youtube.com/watch?v=Aqx3z4Fg1aw)

## Plot summaries:
### Violin plot -
- Grouped by timepoint and cytokine
- Violin plot has a set max width
- IQR range layers over violin plots
- Dot plots layered over IQR range
- File Name Format: TIMEPOINT_CytokineColumn

### Spider plot -
- Grouped by timepoint and treatment
- Dot location determined by median
- Scale is based on log-2-fold-change
- File Name Format: TIMEPOINT_TREATMENT

### PCA plot -
- Grouped by timepoint and treatment
- Clustering includes all treatments in order to have enough data for accurate clusters (IN SOME CASES, THIS MAY BE MISLEADING)
- File Name Format: TIMEPOINT_TREATMENT

# TODO
- heatmaps
- finish pca clustering
- flag some outliers? (on hold?)
- make a guide for formatting .csv input
- put raw data stuff on hold
- put table 1 stuff on hold (santiago)
- figure out why greek letters won't export in csv (don't try .xlsx again, that was a nightmare) (if you do make sure to branch, and don't commit to main) (fix ifn gamma)
- find a way to visual just one value (e.g. NIL) for when they want that

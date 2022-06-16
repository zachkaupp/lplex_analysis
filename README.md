# lplex_data

This project provides graphical information about legendplex data

## to use:

- Clone this repository:
```
git clone https://github.com/zachkaupp/lplex_data.git
```

- Export legendplex data as a .csv, and put it in the `data` directory

- Open `lplex_data.Rproj` in RStudio

- Install the required packages, if you don't have them
```r
# Run these in the R console to install
# all the necessary packages

install.packages(c("tidyverse", "tibble", "scales", "ggfortify", "devtools"))

devtools::install_github("ricardo-bion/ggradar", dependencies = TRUE)
```

- Run R scripts from the `scripts` file in the order they are numbered

- Find output plots in the `output` directory

### Walkthrough:
[![lplex_walkthrough](http://img.youtube.com/vi/Aqx3z4Fg1aw/0.jpg)](http://www.youtube.com/watch?v=Aqx3z4Fg1aw)

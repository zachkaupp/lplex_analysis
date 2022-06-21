## Load necessary packages

# CRAN packages
suppressPackageStartupMessages(library(tidyverse))
library(tibble)
suppressPackageStartupMessages(library(scales))
library(ggfortify)
library(cluster)
suppressPackageStartupMessages(library(crayon))
library(class)
library(glue)
suppressPackageStartupMessages(library(readr))

# GITHUB packages
library(ggradar)
# ^ install with "devtools::install_github("ricardo-bion/ggradar",
# dependencies = TRUE)", but install 'devtools' from CRAN beforehand


print("Process complete")

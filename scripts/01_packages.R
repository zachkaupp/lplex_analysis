## Load necessary packages

# Base packages
library(class)

# CRAN packages
if(!require('tidyverse'))
{
  writeLines(" Getting tidyverse...")
  install.packages("tidyverse", repos='http://cran.us.r-project.org')
  library(tidyverse)
}else{
  library(tidyverse)
}

if(!require('scales'))
{
  writeLines(" Getting scales...")
  install.packages("scales", repos='http://cran.us.r-project.org')
  library(scales)
}else{
  library(scales)
}

if(!require('ggfortify'))
{
  writeLines(" Getting ggfortify...")
  install.packages("ggfortify", repos='http://cran.us.r-project.org')
  library(ggfortify)
}else{
  library(ggfortify)
}

if(!require('cluster'))
{
  writeLines(" Getting cluster...")
  install.packages("cluster", repos='http://cran.us.r-project.org')
  library(cluster)
}else{
  library(cluster)
}

if(!require('crayon'))
{
  writeLines(" Getting crayon...")
  install.packages("crayon", repos='http://cran.us.r-project.org')
  library(crayon)
}else{
  library(crayon)
}

if(!require('glue'))
{
  writeLines(" Getting glue...")
  install.packages("glue", repos='http://cran.us.r-project.org')
  library(glue)
}else{
  library(glue)
}

if(!require('devtools'))
{
  writeLines(" Getting devtools...")
  install.packages("devtools", repos='http://cran.us.r-project.org')
  library(devtools)
}else{
  library(devtools)
}

# GITHUB packages
if(!require('ggradar'))
{
  writeLines(" Getting ggradar...")
  devtools::install_github("ricardo-bion/ggradar", dependencies = TRUE)
  library(ggradar)
}else{
  library(ggradar)
}

if(!require('ComplexHeatmap'))
{
  writeLines(" Getting ComplexHeatmap...")
  devtools::install_github("jokergoo/ComplexHeatmap")
  library(ComplexHeatmap)
}else{
  library(ComplexHeatmap)
}

cat(cyan("Process complete\n"))

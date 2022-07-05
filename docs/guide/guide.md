# Guide

### Video Tutorials

{% embed url="https://www.youtube.com/playlist?list=PLWbNTbtRBJDA1B32GWftrhAApmZ7ur8Pt" %}

### Output

Many of the scripts in `lplex_analysis` produce output. Output is found in the `output` folder, and is created as the scripts are run.

The scripts usually produce functions that can be called to plot in RStudio, but many of the functions are automatically called in the script to populate the `output` folder, so that the functions do not need to be called individually.

```r
# some scripts have this variable at the top of the file,
# and if it is changed to FALSE, the scripts will not
# automatically export plots to the output folder
save_plots <- TRUE
```

#### Plot Naming

Plot output files are named according to the `timepoint_index`, `_`, then whatever other information defines the graph, such as the analyte column number, or treatment index

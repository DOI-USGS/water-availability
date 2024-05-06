library(targets)

tar_option_set(packages = c("sbtools",
                            "tidyverse",
                            "sf",
                            "rmapshaper",
                            "nngeo",
                            "stringr",
                            "gridSVG"))

# Phase target makefiles
#   NEED to run 0_config.R first unless you've already fetched SB items
source("1_fetch.R")
source("2_process.R")
source("3_visualize.R")

# Combined list of target outputs
c(p1_targets, p2_targets, p3_targets)

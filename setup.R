# Author: Clara Feigelson
# Created: 1/19/2023
# Modified last: 1/19/2023

# Package Load Function copied from ESS 523a intro-basics lesson
packageLoad <-
  function(x) {
    for (i in 1:length(x)) {
      if (!x[i] %in% installed.packages()) {
        install.packages(x[i])
      }
      library(x[i], character.only = TRUE)
    }
  }

# create a string of package names
packages <- c('tidyverse',
              'palmerpenguins',
              'sf',
              'terra',
              'tmap',
              'rmarkdown',
              'tigris',
              'elevatr',
              'rgdal')

# applies packages object to packageLoad function
packageLoad(packages)

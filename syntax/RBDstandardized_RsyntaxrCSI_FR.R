library(haven)
library(labelled)
library(tidyverse)

#import dataset
dataset <- read_sav("example_datasets/exampledataEng.sav")

#Calculate HHS
dataset <- to_factor(dataset)

#calculate rCSI Score
dataset <- dataset %>% mutate(rCSI = rCSILessQlty  + (2 * rCSIBorrow) + rCSIMealSize + (3 * rCSIMealAdult) + rCSIMealNb)
var_label(dataset$rCSI) <- "rCSI"


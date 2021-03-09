library(haven)
library(labelled)
library(tidyverse)

#import dataset
dataset <- read_sav("example_datasets/exampledataEnglish_raw.sav")
dataset  <- to_factor(dataset )

##Calculate HHS
#Recode HHS questions into new variables with score
dataset  <- dataset  %>% mutate(HHhSNoFood_FR_r = case_when(
  HHhSNoFood_FR == "Rarely (1–2 times)" ~ 1,
  HHhSNoFood_FR == "Sometimes (3–10 times)" ~ 1,
  HHhSNoFood_FR == "Often (more than 10 times)" ~ 2,
  TRUE ~ 0),
  HHhSBedHung_FR_r = case_when(
    HHhSBedHung_FR == "Rarely (1–2 times)" ~ 1,
    HHhSBedHung_FR == "Sometimes (3–10 times)" ~ 1,
    HHhSBedHung_FR == "Often (more than 10 times)" ~ 2,
    TRUE ~ 0),
  HHhSNotEat_FR_r = case_when(
    HHhSNotEat_FR == "Rarely (1–2 times)" ~ 1,
    HHhSNotEat_FR == "Sometimes (3–10 times)" ~ 1,
    HHhSNotEat_FR == "Often (more than 10 times)" ~ 2,
    TRUE ~ 0))
# Calculate HHhS score
dataset  <- dataset  %>% mutate(HHS = HHhSNoFood_FR_r + HHhSBedHung_FR_r + HHhSNotEat_FR_r)
var_label(dataHHSEng$HHS) <- "Household Hunger Scale"
#each household should have an HHS score between 0 - 6
summary(dataset$HHS)
# Create Categorical HHS
dataset  <- dataset  %>% mutate(HHSCat = case_when(
  HHS %in% c(0,1) ~ "No or little hunger in the household",
  HHS %in% c(2,3) ~ "Moderate hunger in the household",
  HHS >= 4 ~ "Severe hunger in the household"
))
var_label(dataset$HHSCat) <- "Household Hunger Score Categories"










library(haven)
library(labelled)
library(tidyverse)

#import dataset
dataset <- read_sav("example_datasets/exampledataEng.sav")

#Calculate HHS
dataset  <- to_factor(dataset )

#Recode HHS questions into new variables with score
dataset  <- dataset  %>% mutate(HHhSNoFood_FR_r = case_when(
  HHhSNoFood_FR == "Rarement (1 à 2 fois)" ~ 1,
  HHhSNoFood_FR == "Parfois (3 à 10 fois)" ~ 1,
  HHhSNoFood_FR == "Souvent (plus que 10 fois)" ~ 2,
  TRUE ~ 0),
  HHhSBedHung_FR_r = case_when(
    HHhSBedHung_FR == "Rarement (1 à 2 fois)" ~ 1,
    HHhSBedHung_FR == "Parfois (3 à 10 fois)" ~ 1,
    HHhSBedHung_FR == "Souvent (plus que 10 fois)" ~ 2,
    TRUE ~ 0),
  HHhSNotEat_FR_r = case_when(
    HHhSNotEat_FR == "Rarement (1 à 2 fois)" ~ 1,
    HHhSNotEat_FR == "Parfois (3 à 10 fois)" ~ 1,
    HHhSNotEat_FR == "Souvent (plus que 10 fois)" ~ 2,
    TRUE ~ 0))
# Calculate HHS score
dataset  <- dataset  %>% mutate(HHS = HHhSNoFood_FR_r + HHhSBedHung_FR_r + HHhSNotEat_FR_r)
var_label(dataHHSEng$HHS) <- "Indice domestique de la faim"

#each household should have an HHS score between 0 - 6
summary(dataset$HHS)

# Create Categorical HHS
dataset  <- dataset  %>% mutate(HHSCat = case_when(
  HHS %in% c(0,1) ~ "Peu ou pas de faim dans le ménage",
  HHS %in% c(2,3) ~ "Faim modérée dans le ménage",
  HHS >= 4 ~ "Faim sévère dans le ménage"
))
var_label(dataset$HHSCat) <- "Catégories de la faim dans les ménages"



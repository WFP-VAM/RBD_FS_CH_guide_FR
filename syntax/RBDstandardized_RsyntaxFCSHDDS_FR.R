library(haven)
library(labelled)
library(tidyverse)

#import dataset
dataset <- read_sav("example_datasets/exampledataEng.sav")
#convert to labels
dataset <- to_factor(dataset)

#calculate FCS
dataset <- dataset %>% mutate(FCS = (2 * FCSStap) + (3 * FCSPulse)+ (4*FCSPr) +FCSVeg  +FCSFruit +(4*FCSDairy) + (0.5*FCSFat) + (0.5*FCSSugar))
var_label(dataset$FCS) <- "Score de consommation alimentaire"
#create FCG groups based on 21/25 or 28/42 thresholds - analyst should decide which one to use.
dataset <- dataset %>% mutate(
  FCSCat21 = case_when(
    FCS <= 21 ~ "Pauvre", between(FCS, 21.5, 35) ~ "Limite", FCS > 35 ~ "Acceptable"),
  FCSCat28 = case_when(
    FCS <= 28 ~ "Pauvre", between(FCS, 28.5, 42) ~ "Limite", FCS > 42 ~ "Acceptable"))
var_label(dataset$FCSCat21) <- "Groupe de consommation alimentaire - Seuils du 21/35"
var_label(dataset$FCSCat28) <-  "Groupe de consommation alimentaire - Seuils du 28/42"



#calculate HDDS first by creating the 12 groups based on the 16 questions
dataset <- dataset %>% mutate(
  HDDSStapCer = case_when(HDDSStapCer == "Oui" ~ 1, TRUE ~ 0),
  HDDSStapRoot = case_when(HDDSStapRoot  == "Oui" ~ 1, TRUE ~ 0),
  HDDSVeg = case_when(HDDSVegOrg  == "Oui" | HDDSVegGre == "Oui" | HDDSVegOth == "Oui" ~ 1, TRUE ~ 0),
  HDDSFruit = case_when(HDDSFruitOrg == "Oui" | HDDSFruitOth == "Oui" ~ 1, TRUE ~ 0),
  HDDSPrMeat = case_when(HDDSPrMeatF == "Oui" | HDDSPrMeatO == "Oui" ~ 1, TRUE ~ 0),
  HDDSPrEgg = case_when(HDDSPrEgg  == "Oui" ~ 1, TRUE ~ 0),
  HDDSPrFish = case_when(HDDSPrFish == "Oui" ~ 1, TRUE ~ 0),
  HDDSPulse = case_when(HDDSPulse == "Oui" ~ 1, TRUE ~ 0),
  HDDSDairy = case_when(HDDSDairy == "Oui" ~ 1, TRUE ~ 0),
  HDDSFat = case_when(HDDSFat == "Oui" ~ 1, TRUE ~ 0),
  HDDSSugar = case_when(HDDSSugar == "Oui" ~ 1, TRUE ~ 0),
  HDDSCond = case_when(HDDSCond == "Oui"~ 1, TRUE ~ 0))

#Calculate HDDS and Cadre Harmonise Phases
dataset <- dataset %>% mutate(HDDS = HDDSStapCer +HDDSStapRoot +HDDSVeg +HDDSFruit +HDDSPrMeat +HDDSPrEgg +HDDSPrFish +HDDSPulse +HDDSDairy +HDDSFat +HDDSSugar +HDDSCond)
var_label(dataset$HDDS) <- "Score de la diversité alimentaire des ménages"



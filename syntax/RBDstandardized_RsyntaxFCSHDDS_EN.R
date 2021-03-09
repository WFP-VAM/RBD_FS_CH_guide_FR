library(haven)
library(labelled)
library(tidyverse)

#import dataset
dataset <- read_sav("example_datasets/exampledataEnglish_raw.sav")
#convert to labels
dataset <- to_factor(dataset)

#calculate FCS
dataset <- dataset %>% mutate(FCS = (2 * FCSStap) + (3 * FCSPulse)+ (4*FCSPr) +FCSVeg  +FCSFruit +(4*FCSDairy) + (0.5*FCSFat) + (0.5*FCSSugar))
#create FCG groups based on 21/25 or 28/42 thresholds
dataset <- dataset %>% mutate(
  FCSCat21 = case_when(
    FCS <= 21 ~ "Poor", between(FCS, 21.5, 35) ~ "Borderline", FCS > 35 ~ "Acceptable"),
  FCSCat28 = case_when(
    FCS <= 28 ~ "Poor", between(FCS, 28.5, 42) ~ "Borderline", FCS > 42 ~ "Acceptable"))
var_label(dataset$FCSCat21) <- "Food Consumption Group 21/35 thresholds"
var_label(dataset$FCSCat28) <-  "Food Consumption Group 28/42 thresholds"



#calculate HDDS first by creating the 12 groups based on the 16 questions
dataset <- dataset %>% mutate(
  HDDSStapCer = case_when(HDDSStapCer == "Yes" ~ 1, TRUE ~ 0),
  HDDSStapRoot = case_when(HDDSStapRoot  == "Yes" ~ 1, TRUE ~ 0),
  HDDSVeg = case_when(HDDSVegOrg  == "Yes" | HDDSVegGre == "Yes" | HDDSVegOth == "Yes" ~ 1, TRUE ~ 0),
  HDDSFruit = case_when(HDDSFruitOrg == "Yes" | HDDSFruitOth == "Yes" ~ 1, TRUE ~ 0),
  HDDSPrMeat = case_when(HDDSPrMeatF == "Yes" | HDDSPrMeatO == "Yes" ~ 1, TRUE ~ 0),
  HDDSPrEgg = case_when(HDDSPrEgg  == "Yes" ~ 1, TRUE ~ 0),
  HDDSPrFish = case_when(HDDSPrFish == "Yes" ~ 1, TRUE ~ 0),
  HDDSPulse = case_when(HDDSPulse == "Yes" ~ 1, TRUE ~ 0),
  HDDSDairy = case_when(HDDSDairy == "Yes" ~ 1, TRUE ~ 0),
  HDDSFat = case_when(HDDSFat == "Yes" ~ 1, TRUE ~ 0),
  HDDSSugar = case_when(HDDSSugar == "Yes" ~ 1, TRUE ~ 0),
  HDDSCond = case_when(HDDSCond == "Yes"~ 1, TRUE ~ 0))

#Calculate HDDS and Cadre Harmonise Phases
dataset <- dataset %>% mutate(HDDS = HDDSStapCer +HDDSStapRoot +HDDSVeg +HDDSFruit +HDDSPrMeat +HDDSPrEgg +HDDSPrFish +HDDSPulse +HDDSDairy +HDDSFat +HDDSSugar +HDDSCond)
var_label(dataset$HDDS) <- "Hosehold Dietary Diversity Score"


library(haven)
library(labelled)
library(tidyverse)

#import dataset
dataset <- read_sav("example_datasets/exampledataEnglish_raw.sav")

#2 - convert all variables to the labelled version - but first create ADMINCodes
dataset <- dataset %>% mutate(ADMIN1Code = as.character(ADMIN1Name))
dataset <- dataset %>% mutate(ADMIN2Code = as.character(ADMIN2Name))
dataset <- to_factor(dataset)


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
var_label(dataset$HHS) <- "Household Hunger Scale"
#each household should have an HHS score between 0 - 6
summary(dataset$HHS)
# Create Categorical HHS
dataset  <- dataset  %>% mutate(HHSCat = case_when(
  HHS %in% c(0,1) ~ "No or little hunger in the household",
  HHS %in% c(2,3) ~ "Moderate hunger in the household",
  HHS >= 4 ~ "Severe hunger in the household"
))
var_label(dataset$HHSCat) <- "Household Hunger Score Categories"

##calculate rCSI
dataset <- dataset %>% mutate(rCSI = rCSILessQlty  + (2 * rCSIBorrow) + rCSIMealSize + (3 * rCSIMealAdult) + rCSIMealNb)
var_label(dataset$rCSI) <- "rCSI"

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

#calculate HDDS
#first by creating the 12 groups based on the 16 questions
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

#Calculate HDDS
dataset <- dataset %>% mutate(HDDS = HDDSStapCer +HDDSStapRoot +HDDSVeg +HDDSFruit +HDDSPrMeat +HDDSPrEgg +HDDSPrFish +HDDSPulse +HDDSDairy +HDDSFat +HDDSSugar +HDDSCond)
var_label(dataset$HDDS) <- "Hosehold Dietary Diversity Score"

#Calculate LHCS
#stress
dataset <- dataset %>% mutate(stress_coping = case_when(
  LhCSIStress1 %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") ~ "Yes",
  LhCSIStress2 %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") ~ "Yes",
  LhCSIStress3 %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") ~ "Yes",
  LhCSIStress4 %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") ~ "Yes",
  TRUE ~ "No"))
var_label(dataset$stress_coping) <- "Did the HH engage in stress coping strategies"
#Crisis
dataset <- dataset %>% mutate(crisis_coping = case_when(
  LhCSICrisis1 %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") ~ "Yes",
  LhCSICrisis2 %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") ~ "Yes",
  LhCSICrisis3 %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") ~ "Yes",
  TRUE ~ "No"))
var_label(dataset$crisis_coping) <- "Did the HH engage in crisis coping strategies"
#Emergency
dataset <- dataset %>% mutate(emergency_coping = case_when(
  LhCSIEmergency1 %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") ~ "Yes",
  LhCSIEmergency2 %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") ~ "Yes",
  LhCSIEmergency3 %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") ~ "Yes",
  TRUE ~ "No"))
var_label(dataset$emergency_coping) <- "Did the HH engage in emergency coping strategies"
#calculate Max_coping_behaviour
dataset <- dataset %>% mutate(LhCSICat = case_when(
  emergency_coping == "Yes" ~ "EmergencyStrategies",
  crisis_coping == "Yes" ~ "CrisisStrategies",
  stress_coping == "Yes" ~ "StressStrategies",
  TRUE ~ "NoStrategies"))
var_label(dataset$LhCSICat) <- "Livelihood Coping Strategy categories - CARI light version"



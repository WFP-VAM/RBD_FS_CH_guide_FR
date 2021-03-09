library(haven)
library(labelled)
library(tidyverse)

#import dataset
dataset <- read_sav("example_datasets/exampledataEnglish_raw.sav")
dataset<- to_factor(dataset)

#Calculate lhCS


#create a variable to specify if the household used any of the strategies by severity
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




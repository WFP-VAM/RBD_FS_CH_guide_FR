library(haven)
library(labelled)
library(tidyverse)

#import dataset
dataLHCS_ENAEng <- read_sav("example_datasets/dataLHCS_ENAEng.sav")

#Calculate HHS
dataLHCS_ENAEng<- to_factor(dataLHCS_ENAEng)

#create a variable to specify if the household used any of the strategies by severity
#stress
dataLHCS_ENAEng <- dataLHCS_ENAEng %>% mutate(stress_coping = case_when(
  LhCSIStress1_EN %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") &
    LhCSIStress1_EN_why == "To buy food" ~ "usedstress",
  LhCSIStress2_EN %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") &
    LhCSIStress2_EN_why == "To buy food" ~ "usedstress",
  LhCSIStress3_EN %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") &
    LhCSIStress3_EN_why == "To buy food" ~ "usedstress",
  LhCSIStress4_EN %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") &
    LhCSIStress4_EN_why == "To buy food" ~ "usedstress",
  TRUE ~ "notusedstress"))
#Crisis
dataLHCS_ENAEng <- dataLHCS_ENAEng %>% mutate(crisis_coping = case_when(
  LhCSICrisis1_EN %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") &
    LhCSICrisis1_EN_why == "To buy food" ~ "usedcrisis",
  LhCSICrisis2_EN %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") &
    LhCSICrisis2_EN_why == "To buy food" ~ "usedcrisis",
  LhCSICrisis3_EN %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") &
    LhCSICrisis3_EN_why == "To buy food" ~ "usedcrisis",
  TRUE ~ "notusedcrisis"))
#Emergency
dataLHCS_ENAEng <- dataLHCS_ENAEng %>% mutate(emergency_coping = case_when(
  LhCSIEmergency1_EN %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") &
    LhCSIEmergency1_EN_why == "To buy food" ~ "usedemergency",
  LhCSIEmergency2_EN %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") &
    LhCSIEmergency2_EN_why == "To buy food" ~ "usedemergency",
  LhCSIEmergency3_EN %in% c("Yes","No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it") &
    LhCSIEmergency3_EN_why == "To buy food" ~ "usedemergency",
  TRUE ~ "noutusedemergency"))

#calculate Max_coping_behaviour
dataLHCS_ENAEng <- dataLHCS_ENAEng %>% mutate(LhCSICat_ENA = case_when(
  emergency_coping == "usedemergency" ~ "EmergencyStrategies",
  crisis_coping == "usedcrisis" ~ "CrisisStrategies",
  stress_coping == "usedstress" ~ "StressStrategies",
  TRUE ~ "NoStrategies"))
var_label(dataLHCS_ENAEng$LhCSICat_ENA) <- "Livelihood Coping Strategy categories - ENA version"

#Generate table of proportion of households in LhCHS  phases by Adm1 and Adm2 using weights
#Livelihood Coping Strategies
LhHCSCat_table_wide <- dataLHCS_ENAEng %>%
  drop_na(LhCSICat_ENA) %>%
  group_by(ADMIN1Name, ADMIN2Name) %>%
  count(LhCSICat_ENA , wt = WeightHH) %>%
  mutate(perc = 100 * n / sum(n)) %>%
  ungroup() %>% select(-n) %>%
  spread(key = LhCSICat_ENA, value = perc) %>% replace(., is.na(.), 0) %>% mutate_if(is.numeric, round, 1)

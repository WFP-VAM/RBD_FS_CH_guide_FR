library(readr)
library(labelled)
library(haven)
library(tidyr)
library(ggplot2)
library(openxlsx)
library(tidyverse)

#1 - import data and if it is SPSS convert values to labels - need to check later about how to use geocodes
dataset <- read_sav("example_datasets/exampledataEnglish_processed.sav")

#2 - convert all variables to the labelled version - figure out how to split
dataset <- dataset %>% mutate(ADMIN1Code = as.character(ADMIN1Name))
dataset <- dataset %>% mutate(ADMIN2Code = as.character(ADMIN2Name))
dataset <- to_factor(dataset)

#Household Hunger Score
#convert to CH phases
dataset <- dataset %>% mutate(CH_HHS = case_when(
  HHS == 0 ~ "Phase1",
  HHS == 1 ~ "Phase2",
  HHS %in% c(2,3) ~ "Phase3",
  HHS == 4 ~ "Phase4",
  HHS >= 5 ~ "Phase5"))
#calculate % of households in phases and then final phase
CH_HHS_table_wide <- dataset %>% group_by(ADMIN1Name, ADMIN1Code, ADMIN2Name, ADMIN2Code) %>%
  drop_na(CH_HHS) %>%
  count(CH_HHS, wt = WeightHH) %>%
  mutate(perc = 100 * n / sum(n)) %>%
  ungroup() %>% select(-n) %>%
  pivot_wider(names_from = CH_HHS,
              values_from = perc,
              values_fill = list(perc = 0)) %>%
  mutate_if(is.numeric, round, 1) %>%
  mutate(phase2345 = `Phase2` + `Phase3` + `Phase4` + `Phase5`,
         phase345 = `Phase3` + `Phase4` + `Phase5`,
         phase45 = `Phase4` + `Phase5`,
         HHS_finalphase = case_when(
           Phase5 >= 20 ~ 5,
           Phase4 >= 20 | phase45 >= 20 ~ 4,
           Phase3 >= 20 | phase345 >= 20 ~ 3,
           Phase2 >= 20 | phase2345 >= 20 ~ 2,
           TRUE ~ 1)) %>%
  select(ADMIN1Name, ADMIN1Code, ADMIN2Name, ADMIN2Code, HHS_Phase1 = Phase1, HHS_Phase2 = Phase2, HHS_Phase3 = Phase3, HHS_Phase4 = Phase4, HHS_Phase5 = Phase5, HHS_finalphase)


#rCSI
#convert to CH phases
dataset <- dataset %>% mutate(CH_rCSI = case_when(
  rCSI <= 3 ~ "Phase1",
  between(rCSI,4,18) ~ "Phase2",
  rCSI >= 19 ~ "Phase3"))
#calculate % of households in phases and then final phase
CH_rCSI_table_wide <- dataset %>%
  group_by(ADMIN1Name, ADMIN1Code, ADMIN2Name, ADMIN2Code) %>%
  drop_na(CH_rCSI) %>%
  count(CH_rCSI, wt = WeightHH) %>%
  mutate(perc = 100 * n / sum(n)) %>%
  ungroup() %>% select(-n) %>%
  pivot_wider(names_from = CH_rCSI,
              values_from = perc,
              values_fill = list(perc = 0)) %>%
  replace(., is.na(.), 0)  %>% mutate_if(is.numeric, round, 1) %>%
  mutate(rcsi23 = Phase2 + Phase3,
         rCSI_finalphase =
           case_when(
             Phase3 >= 20 ~ 3,
             Phase2 >= 20 | rcsi23 >= 20 ~ 2,
             TRUE ~ 1)) %>%
  select(ADMIN1Name, ADMIN1Code, ADMIN2Name, ADMIN2Code, rCSI_Phase1 = Phase1, rCSI_Phase2 = Phase2, rCSI_Phase3 = Phase3, rCSI_finalphase)

#Food Consumption Groups
#make table of % in food consumption Groups - make sure to use correct threshold
CH_FCSCat_table_wide <- dataset %>%
  drop_na(FCSCat21) %>%
  group_by(ADMIN1Name, ADMIN1Code, ADMIN2Name, ADMIN2Code) %>%
  count(FCSCat = FCSCat21,  wt = WeightHH) %>%
  mutate(perc = 100 * n / sum(n)) %>%
  ungroup() %>% select(-n) %>%
  pivot_wider(names_from = FCSCat,
              values_from = perc,
              values_fill = list(perc = 0)) %>%
  replace(., is.na(.), 0)  %>% mutate_if(is.numeric, round, 1) %>%
#Apply the Cadre Harmonise rules for phasing the Food Consumption Groups
  mutate(PoorBorderline = Poor + Borderline, FCG_finalphase = case_when(
  Poor < 5 ~ 1,  #if less than 5% are in the poor food group then phase 1
  Poor >= 20 ~ 4, #if 20% or more are in the poor food group then phase 4
  between(Poor,5,10) ~ 2, #if % of people are between 5 and 10%  then phase2
  between(Poor,10,20) & PoorBorderline < 30 ~ 2, #if % of people in poor food group are between 20 and 20% and the % of people who are in poor and borderline is less than 30 % then phase2
  between(Poor,10,20) & PoorBorderline >= 30 ~ 3)) %>% #if % of people in poor food group are between 20 and 20% and the % of people who are in poor and borderline is less than 30 % then phase2
  select(ADMIN1Name, ADMIN1Code, ADMIN2Name, ADMIN2Code, FCG_Poor = Poor, FCG_Borderline = Borderline, FCG_Acceptable = Acceptable, FCG_finalphase) #select only relevant variables and order in proper sequence


#Household Dietary Diversity Score
#convert to CH phases
dataset <- dataset %>% mutate(CH_HDDS = case_when(
  HDDS >= 5 ~ "Phase1",
  HDDS == 4 ~ "Phase2",
  HDDS == 3 ~ "Phase3",
  HDDS == 2 ~ "Phase4",
  HDDS < 2 ~ "Phase5"))
#calculate % of households in phases and then final phase
CH_HDDS_table_wide  <- dataset %>%
  drop_na(CH_HDDS) %>%
  group_by(ADMIN1Name, ADMIN1Code, ADMIN2Name, ADMIN2Code) %>%
  count(CH_HDDS, wt = WeightHH) %>%
    mutate(perc = 100 * n / sum(n)) %>%
  ungroup() %>% select(-n) %>%
  pivot_wider(names_from = CH_HDDS,
              values_from = perc,
              values_fill = list(perc = 0)) %>%
    mutate_if(is.numeric, round, 1) %>%
#Apply the 20% rule (if it is 20% in that phase or the sum of higher phases equals 20%)
    mutate(
    phase2345 = `Phase2` + `Phase3` + `Phase4` + `Phase5`, #this variable will be used to see if phase 2 and higher phases equals 20                                 phase345 = `Phase3` + `Phase4` + `Phase5`, #this variable will be used to see if phase 3 and higher phases equal 20% or more
    phase345 = `Phase3` + `Phase4` + `Phase5`,
    phase45 = `Phase4` + `Phase5`, #this variable will be used to see if phase 3 and higher phases equal 20% or more
    HDDS_finalphase = case_when(
    `Phase5` >= 20 ~ 5, #if 20% or more is in phase 5 then assign phase 5
    `Phase4` >= 20 | phase45 >= 20 ~ 4, #if 20% or more is in phase 4 or the sum of phase4 and 5 is more than 20% then assign phase 4
    `Phase3` >= 20 | phase345 >= 20 ~ 3, #if 20% or more is in phase 3 or the sum of phase3, 4 and 5 is more than 20% then assign phase 3
    `Phase2` >= 20 | phase2345 >= 20 ~ 2, #if 20% or more is in phase 2 or the sum of phase 2, 3, 4 and 5 is more than 20% then assign phase 2
     TRUE ~ 1)) %>% #otherwise assign phase 1
  select(ADMIN1Name, ADMIN1Code, ADMIN2Name, ADMIN2Code, HDDS_Phase1 = Phase1, HDDS_Phase2 = Phase2, HDDS_Phase3 = Phase3, HDDS_Phase4 = Phase4, HDDS_Phase5 = Phase5, HDDS_finalphase) #select only relevant variables, rename them with indicator name and order in proper sequence


#Livelihood Coping Strategies
CH_LhCSICat_table_wide <- dataset %>%
  drop_na(LhCSICat) %>%
  group_by(ADMIN1Name, ADMIN1Code, ADMIN2Name, ADMIN2Code) %>%
  count(LhCSICat, wt = WeightHH) %>%
  mutate(perc = 100 * n / sum(n)) %>%
  ungroup() %>% select(-n) %>%
  pivot_wider(names_from = LhCSICat,
              values_from = perc,
              values_fill = list(perc = 0)) %>%
  mutate_if(is.numeric, round, 1) %>%
#Apply the Cadre Harmonise rules for phasing the Livelihood Coping Strategies
 mutate(stresscrisisemergency = StressStrategies + CrisisStrategies + EmergencyStrategies,
    crisisemergency = CrisisStrategies + EmergencyStrategies,
    LhHCSCat_finalphase = case_when(
    EmergencyStrategies >= 20 ~ 4,
    crisisemergency >= 20 & EmergencyStrategies < 20 ~ 3,
    NoStrategies < 80 & crisisemergency < 20 ~ 2,
    NoStrategies >= 80 ~ 1)) %>%
    select(ADMIN1Name, ADMIN1Code, ADMIN2Name, ADMIN2Code, LhHCSCat_NoStrategies = NoStrategies, LhHCSCat_StressStrategies = StressStrategies, LhHCSCat_CrisisStategies = CrisisStrategies, LhHCSCat_EmergencyStrategies = EmergencyStrategies, LhHCSCat_finalphase)



#compile all the direct evidence and contributing factors and export the matrice intermediare excel sheet
matrice_intermediaire_direct <- left_join(CH_FCSCat_table_wide, CH_HDDS_table_wide, by = c("ADMIN1Name", "ADMIN1Code", "ADMIN2Name", "ADMIN2Code")) %>%
  left_join(CH_HHS_table_wide, by = c("ADMIN1Name", "ADMIN1Code", "ADMIN2Name", "ADMIN2Code")) %>%
  left_join(CH_LhCSICat_table_wide, by = c("ADMIN1Name", "ADMIN1Code", "ADMIN2Name", "ADMIN2Code")) %>%
  left_join(CH_rCSI_table_wide, by = c("ADMIN1Name", "ADMIN1Code", "ADMIN2Name", "ADMIN2Code"))

#export as csv file which can then be pasted into the matrice intermediare
matrice_intermediaire_direct %>% write.csv("example_datasets/matrice_intermediaire_direct_en.csv")





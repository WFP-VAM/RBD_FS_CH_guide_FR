library(haven)
library(labelled)
library(tidyverse)

#import dataset
dataset <- read_sav("example_datasets/exampledataFrancais_raw.sav")

#2 - convertir toutes les variables à la version étiquetée - mais créer d'abord des ADMINCodes
dataset <- dataset %>% mutate(ADMIN1Code = as.character(ADMIN1Name))
dataset <- dataset %>% mutate(ADMIN2Code = as.character(ADMIN2Name))
dataset <- to_factor(dataset)


##Calculate HHS
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



##calculate rCSI
dataset <- dataset %>% mutate(rCSI = rCSILessQlty  + (2 * rCSIBorrow) + rCSIMealSize + (3 * rCSIMealAdult) + rCSIMealNb)
var_label(dataset$rCSI) <- "rCSI"

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

#Calculate HDDS
dataset <- dataset %>% mutate(HDDS = HDDSStapCer +HDDSStapRoot +HDDSVeg +HDDSFruit +HDDSPrMeat +HDDSPrEgg +HDDSPrFish +HDDSPulse +HDDSDairy +HDDSFat +HDDSSugar +HDDSCond)
var_label(dataset$HDDS) <- "Score de la diversité alimentaire des ménages"










#Calculate LHCS
#parce que le texte est très long dans les questions - voir si la réponse a été tronquée
levels(dataset$LhCSIStress1)

dataset <- dataset %>% mutate(stress_coping = case_when(
  LhCSIStress1 %in% c("Oui","Non, parce que j’ai déjà vendu ces actifs ou mené cette activité au cours des 12 derniers mois et je ne peux pas c") ~ "Oui",
  LhCSIStress2 %in% c("Oui","Non, parce que j’ai déjà vendu ces actifs ou mené cette activité au cours des 12 derniers mois et je ne peux pas c") ~ "Oui",
  LhCSIStress3 %in% c("Oui","Non, parce que j’ai déjà vendu ces actifs ou mené cette activité au cours des 12 derniers mois et je ne peux pas c") ~ "Oui",
  LhCSIStress4 %in% c("Oui","Non, parce que j’ai déjà vendu ces actifs ou mené cette activité au cours des 12 derniers mois et je ne peux pas c") ~ "Oui",
  TRUE ~ "Non"))
var_label(dataset$stress_coping) <- "le ménage s'est-il engagé dans des stratégies  du stress ?"

#Crisis
dataset <- dataset %>% mutate(crisis_coping = case_when(
  LhCSICrisis1 %in% c("Oui","Non, parce que j’ai déjà vendu ces actifs ou mené cette activité au cours des 12 derniers mois et je ne peux pas c") ~ "Oui",
  LhCSICrisis2 %in% c("Oui","Non, parce que j’ai déjà vendu ces actifs ou mené cette activité au cours des 12 derniers mois et je ne peux pas c") ~ "Oui",
  LhCSICrisis3 %in% c("Oui","Non, parce que j’ai déjà vendu ces actifs ou mené cette activité au cours des 12 derniers mois et je ne peux pas c") ~ "Oui",
  TRUE ~ "Non"))
var_label(dataset$crisis_coping) <- "le ménage s'est-il engagé dans des stratégies d'adaptation aux crises ?"

#Emergency
dataset <- dataset %>% mutate(emergency_coping = case_when(
  LhCSIEmergency1 %in% c("Oui","Non, parce que j’ai déjà vendu ces actifs ou mené cette activité au cours des 12 derniers mois et je ne peux pas c") ~ "Oui",
  LhCSIEmergency2 %in% c("Oui","Non, parce que j’ai déjà vendu ces actifs ou mené cette activité au cours des 12 derniers mois et je ne peux pas c") ~ "Oui",
  LhCSIEmergency3 %in% c("Oui","Non, parce que j’ai déjà vendu ces actifs ou mené cette activité au cours des 12 derniers mois et je ne peux pas c") ~ "Oui",
  TRUE ~ "Non"))
var_label(dataset$emergency_coping) <- "le ménage s'est-il engagé dans des stratégies d'adaptation d'urgence ?"


#calculate Max_coping_behaviour
dataset <- dataset %>% mutate(LhCSICat = case_when(
  emergency_coping == "Oui" ~ "StrategiesdeUrgence",
  crisis_coping == "Oui" ~ "StrategiesdeCrise",
  stress_coping == "Oui" ~ "StrategiesdeStress",
  TRUE ~ "Pasdestrategies"))

var_label(dataset$LhCSICat) <- "Catégories de stratégies d'adaptation aux moyens d'existence - version léger  de CARI"

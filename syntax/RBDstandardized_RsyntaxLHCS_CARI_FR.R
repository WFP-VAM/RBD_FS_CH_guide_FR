library(haven)
library(labelled)
library(tidyverse)

#import dataset
dataset <- read_sav("example_datasets/exampledataFrancais_raw.sav")

#Calculate LHCS -
dataset<- to_factor(dataset)

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

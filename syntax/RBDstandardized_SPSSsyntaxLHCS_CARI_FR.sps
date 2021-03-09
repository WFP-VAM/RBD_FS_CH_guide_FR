
GET
  FILE='exampledataFrancais_raw.sav'.
DATASET NAME DataSet3 WINDOW=FRONT.

*** creer une variable  pour montrer si les strategies de stress etaient  "Oui"" ou "Non, parce que j’ai déjà vendu ces actifs ou mené cette activité au cours des 12 derniers mois et je ne peux pas continuer à le faire"

do if (LhCSIStress1 = 2) | (LhCSIStress1 = 3) |
(LhCSIStress2 = 2) | (LhCSIStress2 = 3) |
(LhCSIStress3 = 2) | (LhCSIStress3 = 3) |
(LhCSIStress4 = 2) | (LhCSIStress4 = 3).
compute stress_coping = 1.
ELSE.
compute stress_coping = 0.
end if.
variable labels stress_coping "le ménage s'est-il engagé dans des stratégies  du stress ?".
value labels stress_coping
0 "Non"
1 "Oui".

*** creer une variable  pour montrer si les strategies de crises etaient  "Oui"" ou "Non, parce que j’ai déjà vendu ces actifs ou mené cette activité au cours des 12 derniers mois et je ne peux pas continuer à le faire"

do if (LhCSICrisis1 = 2) | (LhCSICrisis1 = 3) |
(LhCSICrisis2 = 2) | (LhCSICrisis2 = 3) |
(LhCSICrisis3 = 2) | (LhCSICrisis3 = 3).
compute crisis_coping = 1.
ELSE.
compute crisis_coping = 0.
end if.
variable labels crisis_coping "le ménage s'est-il engagé dans des stratégies d'adaptation aux crises ?".
value labels crisis_coping
0 "Non"
1 "Oui".

*** creer une variable  pour montrer si les strategies de urgences etaient  "Oui"" ou "Non, parce que j’ai déjà vendu ces actifs ou mené cette activité au cours des 12 derniers mois et je ne peux pas continuer à le faire"

do if (LhCSIEmergency1 = 2) | (LhCSIEmergency1  = 3) |
(LhCSIEmergency2 = 2) | (LhCSIEmergency2  = 3) |
(LhCSIEmergency3  = 2) | (LhCSIEmergency3 = 3).
compute emergency_coping = 1.
ELSE.
compute emergency_coping = 0.
end if.
variable labels emergency_coping "le ménage s'est-il engagé dans des stratégies d'adaptation d'urgence ?".
value labels emergency_coping
0 "Non"
1 "Oui".

*** recoder les variables pour calculer une variable de la stratégie d'adaptation la plus sévère utilisée

recode stress_coping (0=0) (1=2).
recode crisis_coping (0=0) (1=3).
recode emergency_coping (0=0) (1=4).

compute LhCSICat=max(stress_coping, crisis_coping, emergency_coping).
recode LhCSICat (0=1).

Value labels LhCSICat 1 "Pasdestrategies" 2 "StrategiesdeStress" 3 "StrategiesdeCrise" 4 "StrategiesdUrgence".
Variable Labels LhCSICat = "Catégories de stratégies d'adaptation aux moyens d'existence - version léger  de CARI".















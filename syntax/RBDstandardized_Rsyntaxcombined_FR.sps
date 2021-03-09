GET  FILE='exampledataFrancais_raw.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

*** calculate HHS

*** recoder les questions de frequence en scores

Recode HHhSNoFood_FR HHhSBedHung_FR HHhSNotEat_FR (1 = 1) (2=1) (3=2) (ELSE=0) INTO HHhSNoFood_FR_r HHhSBedHung_FR_r HHhSNotEat_FR_r.

Variable labels HHhSNoFood_FR_r "Au cours des [4 dernières semaines/30 jours], n'y avait-il aucun aliment à manger à la maison, de quelque nature que ce soit à cause du manque de ressources ? - recode".
Variable labels HHhSBedHung_FR_r "Au cours des [4 dernières semaines/30 jours], étiez-vous ou tout membre de votre ménage obligé de dormir affamé le soir parce qu’il n’y avait pas assez de nourriture ?  - recode".
Variable labels HHhSNotEat_FR_r "Au cours des [4 dernières semaines/30 jours], avez-vous ou tout membre de votre ménage passé un jour et une nuit entière sans rien manger parce qu’il n’y avait pas assez de nourriture ? - recode".

*** additioner les questions recodes pour calculer le HHS

Compute HHS = HHhSNoFood_FR_r + HHhSBedHung_FR_r + HHhSNotEat_FR_r.
variable labels HHS "Indice domestique de la faim".

*** chaque menage devrait avoir un score HHS entre 0 et 6

FREQUENCIES VARIABLES = HHS
/STATISTICS=MEAN MEDIAN MINIMUM MAXIMUM
/ORDER=ANALYSIS.

*** Creer HHS categorique

RECODE HHS (0 thru 1=1) (2 thru 3=2) (4 thru Highest=3) INTO HHSCat.
variable labels HHSCat "Catégories de la faim dans les ménages".
value labels HHSCat
1 `Peu ou pas de faim dans le ménage`
2 `Faim modérée dans le ménage`
3 `Faim sévère dans le ménage`.

*** Calculer rCSI

compute rCSI = sum(rCSILessQlty,rCSIBorrow*2,rCSIMealSize,rCSIMealAdult*3,rCSIMealNb).
Variable labels rCSI "rCSI".

*** chaque menage devrait avoir un rCSI entre 0 et 56

FREQUENCIES VARIABLES =  rCSI
/STATISTICS=MEAN MEDIAN MINIMUM MAXIMUM
/ORDER=ANALYSIS.

** calculer le Score de Consommation Alimentaire

compute FCS = sum(FCSStap*2, FCSPulse*3, FCSDairy*4, FCSPr*4, FCSVeg, FCSFruit, FCSFat*0.5, FCSSugar*0.5).
variable labels FCS "Score de Consommation Alimentaire".

** calculer  des groupes de consommation alimentaire à partir du score de consommation alimentaire - seuils 21/35 et 28/42s

recode FCS (0 thru 21 = 1) (21 thru 35 = 2) (35 thru highest = 3) into FCSCat21.
variable labels FCSCat21 "Groupes de Consommation Alimentaire - seuils 21/35".
recode FCS (0 thru 28 = 1) (28 thru 42 = 2) (42 thru highest = 3) into FCSCat28.
variable labels FCSCat28  "Groupes de Consommation Alimentaire  - seuils 28/42".

VALUE LABELS FCSCat21 FCSCat28
1 "Pauvre"
2 "Limite"
3 "Acceptable".

** calculate Score de diversité alimentaire des ménages

*combine Meat questions

compute HDDSPrMeat = sum(HDDSPrMeatF,HDDSPrMeatO).
recode HDDSPrMeat (0=0) (1 thru highest = 1).

*combine Vegetable questions

compute HDDSVeg = sum(HDDSVegOrg,HDDSVegGre,HDDSVegOth).
recode HDDSVeg (0=0) (1 thru highest = 1).

*combine Fruit questions

compute HDDSFruit = sum(HDDSFruitOrg,HDDSFruitOth).
recode HDDSFruit (0=0) (1 thru highest = 1).

compute HDDS = sum(HDDSStapCer,HDDSStapRoot,HDDSPulse,HDDSDairy,HDDSPrMeat,HDDSPrFish,
HDDSPrEgg,HDDSVeg,HDDSFruit,HDDSFat,HDDSSugar,HDDSCond).
variable labels HDDS "Score de diversité alimentaire des ménages".


***calculate Livelihood Coping Stragegies
** creer une variable  pour montrer si les strategies de stress etaient  "Oui"" ou "Non, parce que j’ai déjà vendu ces actifs ou mené cette activité au cours des 12 derniers mois et je ne peux pas continuer à le faire"

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











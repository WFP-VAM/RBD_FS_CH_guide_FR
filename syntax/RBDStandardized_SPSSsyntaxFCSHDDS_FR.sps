GET
  FILE='exampledataFrancais_raw.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

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







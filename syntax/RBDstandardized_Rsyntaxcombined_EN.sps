*** calculate HHS
** recode the frequency questions to scores

Recode HHhSNoFood_FR HHhSBedHung_FR HHhSNotEat_FR (1 = 1) (2=1) (3=2) (ELSE=0) INTO HHhSNoFood_FR_r HHhSBedHung_FR_r HHhSNotEat_FR_r.

Variable labels HHhSNoFood_FR_r "In the past [4 weeks/30 days], was there ever no food to eat of any kind in your house because of lack of resources to get food? - recoded"
HHhSBedHung_FR_r "In the past [4 weeks/30 days], did you or any household member go to sleep at night hungry because there was not enough food? - recoded"
HHhSNotEat_FR_r "In the past [4 weeks/30 days], did you or any household member go to sleep at night hungry because there was not enough food? - recoded".

** sum the recoded questions to calculate the HHS

Compute HHS = HHhSNoFood_FR_r + HHhSBedHung_FR_r + HHhSNotEat_FR_r.
variable labels HHS "Household Hunger Scale".

** each household should have an HHS score between 0 - 6.

FREQUENCIES VARIABLES = HHS
/STATISTICS=MEAN MEDIAN MINIMUM MAXIMUM
/ORDER=ANALYSIS.

** Create Categorical HHS

RECODE HHS (0 thru 1=1) (2 thru 3=2) (4 thru Highest=3) INTO HHSCat.
variable labels HHSCat "Household Hunger Score Categories".
value labels HHSCat 
1 `No or little hunger in the household`
2 `Moderate hunger in the household`
3 `Severe hunger in the household`.

*** calculate rCSI

compute rCSI = sum(rCSILessQlty,rCSIBorrow*2,rCSIMealSize,rCSIMealAdult*3,rCSIMealNb).
Variable labels rCSI "rCSI".

** each household should have a rCSI between 0 - 56

FREQUENCIES VARIABLES =  rCSI
/STATISTICS=MEAN MEDIAN MINIMUM MAXIMUM
/ORDER=ANALYSIS.


*** Calculate Food Consumption Score

compute FCS = sum(FCSStap*2, FCSPulse*3, FCSDairy*4, FCSPr*4, FCSVeg, FCSFruit, FCSFat*0.5, FCSSugar*0.5).
variable labels FCS "Food Consumption Score".

** Calculate Food Consumption Groups

recode FCS (0 thru 21 = 1) (21 thru 35 = 2) (35 thru highest = 3) into FCSCat21.
variable labels FCSCat21 "Food Consumption Groups - 21/35 thresholds".
recode FCS (0 thru 28 = 1) (28 thru 42 = 2) (42 thru highest = 3) into FCSCat28.
variable labels FCSCat28  "Food Consumption Groups - 28/42 thresholds".

VALUE LABELS FCSCat21 FCSCat28 
1 "Poor"
2 "Borderline"
3 "Acceptable".

*** Calculate Household Dietary Diversity Score

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
variable labels HDDS "Household Dietary Diversity Score".

***calculate Livelihood Coping Stragegies 
** create dummy variable to show if any stress strategies were  "Yes" or "No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it"

do if (LhCSIStress1 = 2) | (LhCSIStress1 = 3) | 
(LhCSIStress2 = 2) | (LhCSIStress2 = 3) |
(LhCSIStress3 = 2) | (LhCSIStress3 = 3) |
(LhCSIStress4 = 2) | (LhCSIStress4 = 3). 
compute stress_coping = 1.
ELSE.
compute stress_coping = 0.
end if. 
variable labels stress_coping "Did the HH engage in stress coping strategies?".
value labels stress_coping 
0 "No"
1 "Yes".

*** create dummy variable to show if any crisis strategies were  "Yes" or "No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it"

do if (LhCSICrisis1 = 2) | (LhCSICrisis1 = 3) | 
(LhCSICrisis2 = 2) | (LhCSICrisis2 = 3) |
(LhCSICrisis3 = 2) | (LhCSICrisis3 = 3). 
compute crisis_coping = 1.
ELSE.
compute crisis_coping = 0.
end if. 
variable labels crisis_coping "Did the HH engage in crisis coping strategies?".
value labels crisis_coping 
0 "No"
1 "Yes".

*** create dummy variable to show if any emergency strategies were  "Yes" or "No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it"

do if (LhCSIEmergency1 = 2) | (LhCSIEmergency1  = 3) | 
(LhCSIEmergency2 = 2) | (LhCSIEmergency2  = 3) |
(LhCSIEmergency3  = 2) | (LhCSIEmergency3 = 3). 
compute emergency_coping = 1.
ELSE.
compute emergency_coping = 0.
end if. 
variable labels emergency_coping "Did the HH engage in emergency coping strategies?".
value labels emergency_coping 
0 "No"
1 "Yes".


*** recode variables to compute one variable of most severe coping strategy used

recode stress_coping (0=0) (1=2).
recode crisis_coping (0=0) (1=3).
recode emergency_coping (0=0) (1=4).

compute LhCSICat=max(stress_coping, crisis_coping, emergency_coping).
recode LhCSICat (0=1).

Value labels LhCSICat 1 "NoStrategies" 2 "StressStrategies" 3 "CrisisStrategies" 4 "EmergencyStrategies".
Variable Labels LhCSICat "Livelihood Coping Strategy Categories - CARI light version".



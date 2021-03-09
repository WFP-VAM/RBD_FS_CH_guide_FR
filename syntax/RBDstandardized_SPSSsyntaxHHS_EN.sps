
GET  FILE='exampledataEnglish_raw.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

*** recode the frequency questions to scores

Recode HHhSNoFood_FR HHhSBedHung_FR HHhSNotEat_FR (1 = 1) (2=1) (3=2) (ELSE=0) INTO HHhSNoFood_FR_r HHhSBedHung_FR_r HHhSNotEat_FR_r.

Variable labels HHhSNoFood_FR_r "In the past [4 weeks/30 days], was there ever no food to eat of any kind in your house because of lack of resources to get food? - recoded"
HHhSBedHung_FR_r "In the past [4 weeks/30 days], did you or any household member go to sleep at night hungry because there was not enough food? - recoded"
HHhSNotEat_FR_r "In the past [4 weeks/30 days], did you or any household member go to sleep at night hungry because there was not enough food? - recoded".

*** sum the recoded questions to calculate the HHS

Compute HHS = HHhSNoFood_FR_r + HHhSBedHung_FR_r + HHhSNotEat_FR_r.
variable labels HHS "Household Hunger Scale".

*** each household should have an HHS score between 0 - 6.

FREQUENCIES VARIABLES = HHS
/STATISTICS=MEAN MEDIAN MINIMUM MAXIMUM
/ORDER=ANALYSIS.

*** Create Categorical HHS

RECODE HHS (0 thru 1=1) (2 thru 3=2) (4 thru Highest=3) INTO HHSCat.
variable labels HHSCat "Household Hunger Score Categories".
value labels HHSCat 
1 `No or little hunger in the household`
2 `Moderate hunger in the household`
3 `Severe hunger in the household`.



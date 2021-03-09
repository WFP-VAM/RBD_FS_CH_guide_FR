
GET
  FILE='exampledataEnglish_raw.sav'.
DATASET NAME DataSet3 WINDOW=FRONT.

*** create dummy variable to show if any stress strategies were  "Yes" or "No; because I already sold those assets or did this activity in the last 12 months and cannot continue to do it"

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

freq emergency_coping.

*** recode variables to compute one variable of most severe coping strategy used

recode stress_coping (0=0) (1=2).
recode crisis_coping (0=0) (1=3).
recode emergency_coping (0=0) (1=4).

compute LhCSICat=max(stress_coping, crisis_coping, emergency_coping).
recode LhCSICat (0=1).

Value labels LhCSICat 1 "NoStrategies" 2 "StressStrategies" 3 "CrisisStrategies" 4 "EmergencyStrategies".
Variable Labels LhCSICat "Livelihood Coping Strategy Categories - CARI light version".















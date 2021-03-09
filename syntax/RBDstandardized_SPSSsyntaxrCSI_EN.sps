GET  FILE='exampledataEnglish_raw.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

*** calculate rCSI

compute rCSI = sum(rCSILessQlty,rCSIBorrow*2,rCSIMealSize,rCSIMealAdult*3,rCSIMealNb).
Variable labels rCSI "rCSI".

*** each household should have a rCSI between 0 - 56

FREQUENCIES VARIABLES =  rCSI
/STATISTICS=MEAN MEDIAN MINIMUM MAXIMUM
/ORDER=ANALYSIS.


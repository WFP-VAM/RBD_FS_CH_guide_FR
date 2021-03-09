GET  FILE='exampledataFrancais_raw.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

*** Calculer rCSI

compute rCSI = sum(rCSILessQlty,rCSIBorrow*2,rCSIMealSize,rCSIMealAdult*3,rCSIMealNb).
Variable labels rCSI "rCSI".

*** chaque menage devrait avoir un rCSI entre 0 et 56

FREQUENCIES VARIABLES =  rCSI
/STATISTICS=MEAN MEDIAN MINIMUM MAXIMUM
/ORDER=ANALYSIS.

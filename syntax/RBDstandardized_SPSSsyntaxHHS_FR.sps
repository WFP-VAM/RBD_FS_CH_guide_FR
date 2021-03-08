
GET  FILE='exampledataFrancais.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

*** recoder les questions de fr�quence en scores

Recode HHhSNoFood_FR HHhSBedHung_FR HHhSNotEat_FR (1 = 1) (2=1) (3=2) (ELSE=0) INTO HHhSNoFood_FR_r HHhSBedHung_FR_r HHhSNotEat_FR_r.

Variable labels HHhSNoFood_FR_r "Au cours des [4 derni�res semaines/30 jours], n'y avait-il aucun aliment � manger � la maison, de quelque nature que ce soit � cause du manque de ressources ? - recod�".
Variable labels HHhSBedHung_FR_r "Au cours des [4 derni�res semaines/30 jours], �tiez-vous ou tout membre de votre m�nage oblig� de dormir affam� le soir parce qu�il n�yavait pas assez de nourriture ? - recod�".
Variable labels HHhSNotEat_FR_r "Au cours des [4 derni�res semaines/30 jours], avez-vous ou tout membre de votre m�nage pass� un jour et une nuit entiers sans rien manger parce qu�il n�y avait pas assez de nourriture ? - recod�".
 
*** additioner les questions recod�es pour calculer le HHS

Compute HHS = HHhSNoFood_FR_r + HHhSBedHung_FR_r + HHhSNotEat_FR_r.
variable labels HHS "Indice domestique de la faim".

*** chaque m�nage devrait avoir un score HHS entre 0 et 6

FREQUENCIES VARIABLES = HHS
/STATISTICS=MEAN MEDIAN MINIMUM MAXIMUM
/ORDER=ANALYSIS.

*** Cr�er HHS cat�gorique

RECODE HHS (0 thru 1=1) (2 thru 3=2) (4 thru Highest=3) INTO HHSCat.
variable labels HHSCat "Cat�gories de la faim dans les m�nages".
value labels HHSCat 
1 `Peu ou pas de faim dans le m�nage`
2 `Faim mod�r�e dans le m�nage`
3 `Faim s�v�re dans le m�nage`.




GET  FILE='exampledataFrancais_raw.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

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



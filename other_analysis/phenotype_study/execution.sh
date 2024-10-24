#! /usr/bin/env bash

module load python/3.8.10

PATH=/mnt/home/users/bio_267_uma/elenads/scripts/py_scripts:$PATH
export PATH



hpo=PATH_TO_OUTPUT_FILES/external_data/hp.obo
sig_hpo=PATH_TO_OUTPUT_FILES/processed_data/Orphanet/representative_cdg_phen

cut -f 1,2,5 $sig_hpo | tail -n +2 > sig_phen 

#Nervous system
mkdir nervous_system
classify_phen_by_parental.py -o $hpo -t "HP:0000707" -p sig_phen > nervous_system/Abnormality_of_the_nervous_system.txt
classify_phen_by_parental.py -o $hpo -t "HP:0012639" -p sig_phen > nervous_system/nervous_system_morphology.txt
classify_phen_by_parental.py -o $hpo -t "HP:0012638" -p sig_phen > nervous_system/nervous_system_physiology.txt

#Cardiovascular system
mkdir cardiovascular_system
classify_phen_by_parental.py -o $hpo -t "HP:0001626" -p sig_phen > cardiovascular_system/Abnormality_of_the_cardiovascular_system.txt

#Musculoskeletal system
mkdir musculoskeletal
classify_phen_by_parental.py -o $hpo -t "HP:0033127" -p sig_phen > musculoskeletal/Abnormality_of_the_musculoskeletal_system.txt
classify_phen_by_parental.py -o $hpo -t "HP:0000924" -p sig_phen > musculoskeletal/skeletal.txt
classify_phen_by_parental.py -o $hpo -t "HP:0003011" -p sig_phen > musculoskeletal/musculo.txt

#Digestive system
mkdir digestive
classify_phen_by_parental.py -o $hpo -t "HP:0025031" -p sig_phen > digestive/digestive.txt
classify_phen_by_parental.py -o $hpo -t "HP:0011024" -p sig_phen > digestive/tract.txt
classify_phen_by_parental.py -o $hpo -t "HP:0025032" -p sig_phen > digestive/digestive_physiology.txt

#Ear abnormalities
mkdir ear
classify_phen_by_parental.py -o $hpo -t "HP:0000598" -p sig_phen > ear/ear.txt
classify_phen_by_parental.py -o $hpo -t "HP:0031704" -p sig_phen > ear/ear_physiology.txt
classify_phen_by_parental.py -o $hpo -t "HP:0031703" -p sig_phen > ear/ear_morphology.txt

#Eye abnormalities
mkdir eye
classify_phen_by_parental.py -o $hpo -t "HP:0000478" -p sig_phen > eye/eye.txt
classify_phen_by_parental.py -o $hpo -t "HP:0012372" -p sig_phen > eye/eye_morphology.txt
classify_phen_by_parental.py -o $hpo -t "HP:0012373" -p sig_phen > eye/eye_physiology.txt

#Genitourinary system
mkdir genitourinary
classify_phen_by_parental.py -o $hpo -t "HP:0000119" -p sig_phen > genitourinary/genitourinary.txt
classify_phen_by_parental.py -o $hpo -t "HP:0000078" -p sig_phen > genitourinary/genital.txt
classify_phen_by_parental.py -o $hpo -t "HP:0000079" -p sig_phen > genitourinary/urinary.txt

#growth abnormalities
mkdir growth
classify_phen_by_parental.py -o $hpo -t "HP:0001507" -p sig_phen > growth/growth.txt

mkdir head_neck
classify_phen_by_parental.py -o $hpo -t "HP:0000152" -p sig_phen > head_neck/head_neck.txt
classify_phen_by_parental.py -o $hpo -t "HP:0000464" -p sig_phen > head_neck/neck.txt
classify_phen_by_parental.py -o $hpo -t "HP:0000234" -p sig_phen > head_neck/head.txt

mkdir inmune_system
classify_phen_by_parental.py -o $hpo -t "HP:0002715" -p sig_phen > inmune_system/abnormality_inmune_system.txt

mkdir integument
classify_phen_by_parental.py -o $hpo -t "HP:0001574" -p sig_phen > integument/integument.txt

mkdir limbs
classify_phen_by_parental.py -o $hpo -t "HP:0040064" -p sig_phen > limbs/Abnormality_of_limbs.txt
classify_phen_by_parental.py -o $hpo -t "HP:0002817" -p sig_phen > limbs/upper_limbs.txt
classify_phen_by_parental.py -o $hpo -t "HP:0002814" -p sig_phen > limbs/lower_limbs.txt

mkdir respiratory
classify_phen_by_parental.py -o $hpo -t "HP:0002086" -p sig_phen > respiratory/respiratory.txt
classify_phen_by_parental.py -o $hpo -t "HP:0012252" -p sig_phen > respiratory/respiratory_morphology.txt
classify_phen_by_parental.py -o $hpo -t "HP:0002795" -p sig_phen > respiratory/respiratory_physiology.txt

#Other Systems
classify_phen_by_parental.py -o $hpo -t "HP:0000818" -p sig_phen > endocrine.txt
classify_phen_by_parental.py -o $hpo -t "HP:0001197" -p sig_phen > prenatal.txt
classify_phen_by_parental.py -o $hpo -t "HP:0000769" -p sig_phen > breast.txt
classify_phen_by_parental.py -o $hpo -t "HP:0001939" -p sig_phen > metabolism_homeostasis.txt
classify_phen_by_parental.py -o $hpo -t "HP:0001871" -p sig_phen > blood_forming_tissues.txt
classify_phen_by_parental.py -o $hpo -t "HP:0002664" -p sig_phen > neoplasm.txt
classify_phen_by_parental.py -o $hpo -t "HP:0025354" -p sig_phen > cellular_phenotype.txt
classify_phen_by_parental.py -o $hpo -t "HP:0025142" -p sig_phen > constitutional_symptom.txt

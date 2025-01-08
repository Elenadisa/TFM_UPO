#! /usr/bin/env bash

#LOAD R AND PYTHON
module load python/3.8.10
module load R/4.1.0

current_dir=`pwd`

PATH=$current_dir'/scripts/rscripts':$PATH
PATH=$current_dir'/scripts/py_scripts':$PATH
export PATH

mkdir external_data
mkdir processed_data
mkdir processed_data/Orphanet
mkdir results

																	## DOWNLOAD DATASETS // INPUT FILES

#2024/07/15 download
curl http://data.bioontology.org/ontologies/ORDO_OBO/submissions/1/download?apikey=8b5b7825-538d-40e0-9e9e-5ab9274a9aeb > external_data/orphanet_ordo.obo

wget https://raw.githubusercontent.com/obophenotype/human-phenotype-ontology/master/hp.obo -O external_data/hp.obo
wget http://purl.obolibrary.org/obo/hp/hpoa/genes_to_phenotype.txt -O external_data/genes_to_phenotype.txt
wget http://purl.obolibrary.org/obo/mondo.obo -O external_data/mondo.obo


																			#ORPHANET NEUROMUSCULAR DISEASES

#Look for Orphanet diseases in HPO dataset
grep "ORPHA:" external_data/genes_to_phenotype.txt > processed_data/Orphanet/ORPHA_dictionary
cut -f 6,3 processed_data/Orphanet/ORPHA_dictionary | sort -u > processed_data/Orphanet/orpha_disease2phen

echo -e "Total_Orphanet_diseases_in_HPO\t`cut -f 6 processed_data/Orphanet/ORPHA_dictionary | sort -u | wc -l`" >> results/orpha_summary
echo -e "Total_Orphanet_phenotypes\t`cut -f 3 processed_data/Orphanet/ORPHA_dictionary | sort -u | wc -l`" >> results/orpha_summary
echo -e "Total_Orphanet_genes\t`cut -f 1 processed_data/Orphanet/ORPHA_dictionary | sort -u | wc -l`" >> results/orpha_summary
cut -f 1  processed_data/Orphanet/ORPHA_dictionary | sort -u > processed_data/Orphanet/orpha_genes

cut -f 3,4 processed_data/Orphanet/ORPHA_dictionary | sort -u > processed_data/hpo_dictionary

#Get disease subgroup of interest in orphanet diseases with HPO
parse_diseases.py -d external_data/list_of_cdg.txt -n external_data/genes_to_phenotype.txt -b 5 -y 2 | sort -u > processed_data/Orphanet/orphanet_cdg_disease2phen

echo -e "Total_Orphanet_disorders_glycosylation_in_HPO\t`cut -f 1 processed_data/Orphanet/orphanet_cdg_disease2phen | sort -u | wc -l`" >> results/orpha_summary

cut -f 1 processed_data/Orphanet/orphanet_cdg_disease2phen | sort -u > processed_data/Orphanet/orpha_disorders_glycosilation_list

#Get fisher to obtain representative phenotypes
fisher_disease_group.R -i processed_data/Orphanet/ORPHA_dictionary -g processed_data/Orphanet/orpha_disorders_glycosilation_list -d  processed_data/Orphanet/cdg_orphanet_data -o processed_data/Orphanet/representative_cdg_phen -O processed_data/Orphanet/all_phenotypes_fisher -p processed_data/Orphanet/bh_representative_cdg_phen
cut -f 1 processed_data/Orphanet/representative_cdg_phen | tail -n +2 > processed_data/Orphanet/list_significant_cdg_phen
cut -f 1 processed_data/Orphanet/bh_representative_cdg_phen | tail -n +2 > processed_data/Orphanet/bh_list_significant_cdg_phen

#obtain frequency tables
cut -f 1,2,3 processed_data/Orphanet/representative_cdg_phen > processed_data/Orphanet/orpha_disorders_glycosilation_hpo_frequency.txt
cut -f 1,2,4 processed_data/Orphanet/representative_cdg_phen > processed_data/Orphanet/orpha_non_disorders_glycosilation_hpo_frequency.txt

echo -e "Number_representative_phenotypes\t`cut -f 1 processed_data/Orphanet/list_significant_cdg_phen | sort -u | wc -l`" >> results/orpha_summary

glycosylation_freq=/mnt/home/users/bio_267_uma/elenads/projects/metabolic_diseases/processed_data/Orphanet/orpha_disorders_glycosilation_hpo_frequency.txt
non_glycosylation_freq=/mnt/home/users/bio_267_uma/elenads/projects/metabolic_diseases/processed_data/Orphanet/orpha_non_disorders_glycosilation_hpo_frequency.txt

#PATH TO THE DIRECTORY WHERE TO SAVE THE RESULTS
mkdir PATH_TO_OUTPUT_FILES'/disorders_glycosylation'
mkdir PATH_TO_OUTPUT_FILES'/disorders_glycosylation/Orphanet'
mkdir PATH_TO_OUTPUT_FILES'/disorders_glycosylation/Orphanet/build_networks'


# LOAD AUTOFLOW
source ~soft_bio_267/initializes/init_autoflow


#SET AUTOFLOW VARIABLES

variables=`echo -e "
	\\$current_dir=$current_dir,
	\\$database=Orphanet,
	\\$disease2phen=$current_dir'/processed_data/Orphanet/orpha_disease2phen',
	\\$list_glycosylation_disorders_hpo=$current_dir'/processed_data/Orphanet/list_significant_cdg_phen',
	\\$metric_type=hypergeometric,
	\\$association_thresold=2,
	\\$disease_dictionary=$current_dir'/external_data/genes_to_phenotype.txt',
	\\$dictionary=$current_dir'/processed_data/Orphanet/ORPHA_dictionary',
	\\$p_values=0.05,
	\\$number_of_random_models=50,
	\\$glycosylation_freq=$glycosylation_freq,
	\\$non_glycosylation_freq=$non_glycosylation_freq,	
	

" | tr -d [:space:]`

#FOR SLURM SYSTEMS
AutoFlow -w build_networks.af -o PATH_TO_OUTPUT_FILES/disorders_glycosylation/Orphanet/build_networks -V $variables -m 100gb $1 -n cal -t '120:00:00'
#FOR LOCAL UNIX
#AutoFlow -w build_networks.af -oPATH_TO_OUTPUT_FILES/disorders_glycosylation/Orphanet/build_networks -V $variables -b

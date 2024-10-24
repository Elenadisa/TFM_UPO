#! /usr/bin/env bash


current_dir=`pwd`


export PATH=$current_dir'/scripts/py_scripts:'$PATH
export PATH=$current_dir'/scripts/rscripts:'$PATH


#PATH TO build_networks.sh RESULTS
data_source=$FSCRATCH'/disorders_glycosylation_upo/Orphanet/build_networks'
bh_data_source=$FSCRATCH'/disorders_glycosylation_upo/Orphanet/bh_build_networks'

#PATH TO DIRECTORY WITH PAIRS LISTS
real_networks_source=$data_source"/ln_0000/real_networks"
random_networks_source=$data_source"/ln_0000/random_networks"


#OTHER FILES PATH
hpo_dictionary=$current_dir'/processed_data/hpo_dictionary'
all_diseases_data=$current_dir"/external_data/genes_to_phenotype.txt"
phen2gene=$data_source'/cut_0000/test/phen2gene_HyI_2.txt'
single_enrichments=$data_source"/ln_0001"

#obtain networks
ls $real_networks_source > orphanet_real_working_nets
ls $random_networks_source > orphanet_random_working_nets


## PATH TO THE DIRECTORY WHERE TO SAVE THE RESULTS
mkdir $FSCRATCH'/disorders_glycosylation_upo/Orphanet'
mkdir $FSCRATCH'/disorders_glycosylation_upo/Orphanet/analysed_networks'



																	#LOAD AUTOFLOW
#CLUSTER COHERENT ANALYSIS
source ~soft_bio_267/initializes/init_autoflow

# PREPARE VARIABLES NEEDED IN analyse_networks.af
#\\$p_values=0.05/0.001/0.00001,

#		\\$HPO2pubmed=$HPO2pubmed,

while read NETWORK
do
	variables=`echo -e "
		\\$working_net=$real_networks_source/$NETWORK,
		\\$current_dir=$current_dir,
		\\$hpo_dictionary=$hpo_dictionary,
		\\$single_enrichments=$single_enrichments,
		\\$p_values=0.05,
		\\$database=Orphanet,
		\\$all_diseases_data=$all_diseases_data,
		\\$phen2gene=$phen2gene,

	" | tr -d [:space:]`
	
	#FOR SLURM SYSTEM 
	AutoFlow -w analyse_networks.af -o $FSCRATCH'/disorders_glycosylation_upo/Orphanet/analysed_networks/'$NETWORK -V $variables $1 -m 100gb -t '10:00:00' -n 'cal'
	#FOR LOCAL UNIX
	#AutoFlow -w analyse_networks.af -o PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/Orphanet/$NETWORK -V $variables $1 -b
done < orphanet_real_working_nets

while read NETWORK
do
	variables=`echo -e "
		\\$working_net=$random_networks_source/$NETWORK,
		\\$current_dir=$current_dir,
		\\$hpo_dictionary=$hpo_dictionary,
		\\$single_enrichments=$single_enrichments,
		\\$p_values=0.05,
		\\$database=Orphanet,
		\\$all_diseases_data=$all_diseases_data,
		\\$phen2gene=$phen2gene,
		\\$HPO2pubmed=$HPO2pubmed,

	" | tr -d [:space:]`
	
	#FOR SLURM SYSTEM 
	AutoFlow -w analyse_random_networks.af -o $FSCRATCH'/disorders_glycosylation_upo/Orphanet/analysed_networks/'$NETWORK -V $variables $1 -m 100gb -t '10:00:00' -n 'cal'
	
done < orphanet_random_working_nets

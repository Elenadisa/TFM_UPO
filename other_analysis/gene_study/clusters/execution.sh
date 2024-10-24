#! /usr/bin/env bash

#LOAD R AND PYTHON
module load python/3.8.10
module load R/4.1.0

PATH=/mnt/home/users/bio_267_uma/elenads/projects/metabolic_diseases/scripts/rscripts:$PATH
PATH=/mnt/home/users/bio_267_uma/elenads/scripts/py_scripts:$PATH
export PATH

orpha_cdg_data=/mnt/home/users/bio_267_uma/elenads/projects/metabolic_diseases/processed_data/Orphanet/cdg_orphanet_data

cluster_genes50=/mnt2/fscratch/users/bio_267_uma/elenads/disorders_glycosylation_upo/Orphanet/analysed_networks/glycosylation_disorders/cat_0000/clusters_with_50_coherence_0.05
cluster_genes70=/mnt2/fscratch/users/bio_267_uma/elenads/disorders_glycosylation_upo/Orphanet/analysed_networks/glycosylation_disorders/cat_0000/clusters_with_70_coherence_0.05

#Obtain the list of genes associates to out list of CDGs in Orphanet
cut -f 2 $orpha_cdg_data | sort -u > known_genes.txt

#Obtain the list of genes associated to clusters at 50% coherence
cut -f 5 $cluster_genes50 | tr ', ' '\n' | sort -u | tail -n +2 > genes_in_clusters50.txt
#Obtain the list of genes associated to clusters at 70% coherence
cut -f 5 $cluster_genes70 | tr ', ' '\n' | sort -u | tail -n +2 > genes_in_clusters70.txt


#Compare known genes with 50% coherence genes in clusters
gene_comparator.py -k known_genes.txt -c $cluster_genes50 -g 4 -o common_gene_list50.txt > summary50.txt
get_venndiagram.R -i known_genes.txt -I genes_in_clusters50.txt -c V1 -C V1  -t "CDG-Gene Study" -o "cdg_gene_study_50.png"

#Compare known genes with 50% coherence genes in clusters
gene_comparator.py -k known_genes.txt -c $cluster_genes70 -g 4 -o common_gene_list70.txt > summary70.txt
get_venndiagram.R -i known_genes.txt -I genes_in_clusters70.txt -c V1 -C V1  -t "CDG-Gene Study" -o "cdg_gene_study_70.png"
#! /usr/bin/env bash

#LOAD R AND PYTHON
module load python/3.8.10
module load R/4.1.0

PATH=/mnt/home/users/bio_267_uma/elenads/projects/metabolic_diseases/scripts/rscripts:$PATH
PATH=/mnt/home/users/bio_267_uma/elenads/scripts/py_scripts:$PATH
export PATH

orpha_cdg_data=/mnt/home/users/bio_267_uma/elenads/projects/metabolic_diseases/processed_data/Orphanet/cdg_orphanet_data

tripartite=/mnt2/fscratch/users/bio_267_uma/elenads/disorders_glycosylation_upo/Orphanet/build_networks/cut_0000/test/glycosylation_phen2gene_HyI_2.txt
#cut -f 2 $tripartite | sort -u | wc -l

translate_genes.R -i $tripartite -c 2 > tripartite_genes.txt
#wc -l tripartite_genes.txt

#Compare known genes with 50% coherence genes in clusters
gene_comparator.py -k known_genes.txt -c tripartite_genes.txt -g 0 -o common_gene_list_tripartite.txt > summary_tripartite.txt
get_venndiagram.R -i known_genes.txt -I tripartite_genes.txt -c V1 -C V1  -t "CDG-Gene Study" -o "cdg_gene_study_tripartite.png"


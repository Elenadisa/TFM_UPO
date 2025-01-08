#! /usr/bin/env bash
#SBATCH --cpu=1
#SBATCH --mem=4gb
#SBATCH --time=1-00:00:00
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out

#LOAD R
module load R/4.1.0
module load anaconda/2022.10

PATH=/mnt/home/users/bio_267_uma/elenads/scripts/rscripts:$PATH
PATH=/mnt/home/users/bio_267_uma/elenads/scripts/py_scripts:$PATH
export PATH

current_dir=`pwd`

mkdir results

orphanet_build_results_source=/PATH_TO_OUTPUT_FILES/disorders_glycosylation/Orphanet/build_networks
orphanet_analysed_results_source=/PATH_TO_OUTPUT_FILES/disorders_glycosylation/Orphanet/analysed_networks



																	#Orphanet Results
#Clusters Results
cat $orphanet_build_results_source/metrics > results/orphanet_metrics
cat $orphanet_analysed_results_source/*/metrics >> results/orphanet_metrics
cat $orphanet_build_results_source/gene_metrics > results/orphanet_gene_table
cat $orphanet_analysed_results_source/*/topological_metrics >> results/orphanet_metrics
create_metric_table.py -i results/orphanet_metrics -o results/orphanet_table_metrics.txt

#Create reports
create_report.R -t report_templates/orphanet_report_template.Rmd -o results/orphanet_report.html -d results/orphanet_table_metrics.txt,results/orpha_summary,results/orphanet_gene_table -H t,f,f

create_report.R -t report_templates/orphanet_linkcomm_report_template.Rmd -o results/orphanet_clusters_details.html -d results/orphanet_table_metrics.txt -H t
create_report.R -t report_templates/orphanet_linkcomm_report_template_without_go.Rmd -o results/orphanet_clusters_details_without_go.html -d results/orphanet_table_metrics.txt -H t


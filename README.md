# TFM_UPO

This repository has the code for my master dissertation (TFM) entitled "Use of phenotypic comorbidity networks for the study of congenital defects of glycosylation", to obtain the certificate of Master in "Analisis Bioinformático Avanzado" of Pablo Olavide University.  
This work consists in a workflow built in Autoflow that enables the user to search for clusters of co-occurrent phenotypes based on diseases networks. The workflow uses diseases data to connect phenotypes. Moreover, it also assigns genes to these phenotypes and performs functional assignment for biological functions. Finally, it identifies phenotypically coherent clusters of comorbid phenotypes that share biological functions.

# Systems Requirements

This workflow can be run in any linux system and in a supercomputer with SLURM queue system.  
The workflow use python and R scripts, for each language you will need to install their corresponding libraries (see Installation section). Moreover, it use some bash command line function. Finally it will be necessary to download scripts from the group repository [sys_bio_lab](https://github.com/seoanezonjic/sys_bio_lab_scripts/tree/65d5dfd061e624f57f7a48b59af997c50e6b6a27).

# Installation

**I** Clone this repository.  
**II** Install ruby and the ruby gems AutoFlow and NetAnalyzer with the following code:

```
gem install autoflow  

gem install NetAnalyzer
```

**III** Install [Python 3](https://www.python.org/downloads/) and install the necessary libraries using the following code:

```
sudo apt update  

sudo apt -y upgrade  
  
sudo apt install -y python3-pip  
  
pip3 install optparse-pretty numpy os.path2 pandas scipy 
```

**IV**  Instal [R](https://cloud.r-project.org/). The following R packages must also be installed:

```
install.packages(c('optparse', 'ggplot2', 'dplyr', 'reshape', 'knitr', 'linkcomm', 'igraph', 'kableExtra', 'rmarkdown', 'BiocManager', 'VertexSort'))
```

Furthermore, these bioconductor packages should be installed using the the BiocManager package
  
```
BiocManager::install(c("clusterProfiler", "ReactomePA", "org.Hs.eg.db", "DOSE", "GO.db", "GOSim"))
```

# Workflow Execution

## Workflow elements

- **Autoflow templates:** There are three *.sh* scripts that execute their correspond autoflow template *.af*. These scripts are located in the main directory:  
1. launch_orphanet_build_networks.sh - generate phenotype-phenotype, phenotype-gene and phenotype-function pairs from Orphanet data.  
2. launch_orphanet_analyse_network.sh  - obtain phenotype clusters.  
3. get_orphanet_reports.sh - generates html graphical report with the results.  

- **Scripts:** Script directory contain the script that will be executed allong the workflow. There is a directory for each programming language used (Python (/py_scripts), R (/rscript).  
  
- **Report templates:** Directory contains RMarkdown templates to obtain the results.
  
##  Defining input/output paths.

User have to define input/output paths in launch scripts (.sh) - *PATH_TO_OUTPUT_FILES*.

## Make PATH accesible all the installed software  

As different programming languages are used, the path must be made accessible for all installed software.  

## Make PATH accesible the folder scripts  

Make sure that the path accesible for the scripts directory in the different workflow parts.  



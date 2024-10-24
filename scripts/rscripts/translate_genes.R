#! /usr/bin/env Rscript

#@author Elena D. Díaz Santiago
#@description Translate entrez ID to SYMBOL/HUGO

require(org.Hs.eg.db)
require(optparse)




#############################################################################################################################################################################
#																OPTPARSE 																									#
#############################################################################################################################################################################
option_list <- list(
  make_option(c("-i", "--input"), type="character",
              help="input file"),
  make_option(c("-c", "--column"), type="integer",
              help="column with genes")
)

opt <- parse_args(OptionParser(option_list=option_list))



#############################################################################################################################################################################
#																MAIN 																										#
#############################################################################################################################################################################

df <- read.table(opt$input, sep="\t", stringsAsFactors = FALSE, header = FALSE)
gene_l <- as.character(unique(df[,opt$column]))

#map entrez to symbol
#mapIds(org.Hs.eg.db, gene_l, 'SYMBOL', 'ENTREZID')


#map entrez to symbol
symbol_gene_l <- mapIds(org.Hs.eg.db, gene_l, 'SYMBOL', 'ENTREZID')

for(gene in symbol_gene_l){
	cat(paste0(gene[[1]], "\n"))
}
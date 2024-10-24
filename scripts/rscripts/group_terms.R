#! /usr/bin/env Rscript

require(optparse)
require(dplyr)


###################################################################################################################################
#                                            OPTPARSE                                                                             #
###################################################################################################################################
option_list <- list(
  make_option(c("-i", "--input"), type="character",
              help="Dataframe with results 1"),
  make_option(c("-o", "--output"), type="character",
  				help="output file name")
)

opt <- parse_args(OptionParser(option_list=option_list))


##################################################################################################################################
#													METHODS																		#
#################################################################################################################################

df <- read.table(opt$input, sep="\t", header = FALSE)

df1 <- df %>% group_by(V1) %>% summarise(gene_l = paste(V2, collapse = ","))

write.table(df1, opt$output, sep="\t", row.names = FALSE, col.name = FALSE, quote = FALSE)
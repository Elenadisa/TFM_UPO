#! /usr/bin/env Rscript
require(optparse)
require(igraph)
require(VertexSort)

#############################################################################################################################################################################
#																OPTPARSE 																									#
#############################################################################################################################################################################
option_list <- list(
  make_option(c("-i", "--input"), type="character",
              help="Network input file"),
  make_option(c("-o", "--output"), type="character",
              help="Network output file")
)

opt <- parse_args(OptionParser(option_list=option_list))

#############################################################################################################################################################################
#																MAIN 																										#
#############################################################################################################################################################################
df <- read.table(opt$input, sep="\t", stringsAsFactors = FALSE, header = FALSE)
g <- graph.data.frame(df, directed = FALSE)

rand_g <- dpr(g, 1)

df <- as.data.frame(get.edgelist(rand_g[[1]]))
write.table(df, opt$output, sep="\t", quote = FALSE, col.names = FALSE, row.names = FALSE)


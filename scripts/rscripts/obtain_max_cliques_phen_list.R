#! /usr/bin/env Rscript
require(optparse)
require(igraph)
require(utils)




# Prepare input commands
#############################################################################################################################################################################
#																OPTPARSE 																									#
#############################################################################################################################################################################
option_list <- list(
  make_option(c("-i", "--input"), type="character",
              help="Network input file"),
  make_option(c("-o", "--output"), type="character",
              help="Network output file"),
  make_option(c("-m", "--min_vertex"), type="integer",
              help="Minimun number of vertex in a clique")
)

opt <- parse_args(OptionParser(option_list=option_list))



#############################################################################################################################################################################
#																MAIN 																										#
#############################################################################################################################################################################

df  <- read.table(opt$input, sep = "\t") 
#Convert to a graph object
g <- graph.data.frame(df, directed = FALSE)

mc <- max_cliques(g, min = opt$min_vertex)
n <- 0

for(clique in mc){
  n <- n + 1
  c <- paste0(names(unlist(clique)), collapse = ",")
  cat(paste(n, c, sep="\t"), "\n")
}

#cliqueBP <- matrix(c(rep(paste0("cl", seq_along(cliques)), sapply(cliques, length)), names(unlist(cliques))), ncol=2, )

#! /usr/bin/env Rscript

library(optparse)
library(R.utils)
library(ggplot2)
library(rmarkdown)
library(canvasXpress)
library(Rmisc)
library(gridExtra)
library(plyr)
library(knitr)
library(dplyr)
library(kableExtra)
library(igraph)
library(plotly)
library(tinytex)
library(aplot)

########################################################################
## FUNCTIONS
########################################################################
load_files <-function(file_names, headers, read_table_parameters){
	argument_list_for_read_table <- parse_arguments(read_table_parameters)
	data <- list()
	count = 1
	for (file_path in file_names){
        	if(headers[count] == 't'){
                	header = TRUE
	        }else if(headers[count] == 'f'){
        	        header = FALSE
	        }
		argument_list_for_read_table['file'] = file_path
		argument_list_for_read_table['header'] = header
        	data[[basename(file_path)]] = do.call(read.table, argument_list_for_read_table)
	        count = count + 1
	}
	return(data)
}

parse_arguments <- function( parameter_string){
	argument_list <- list()
	pairs <- unlist(strsplit(parameter_string, ','))
	for (i in 1:length(pairs)) { 
        	members = unlist(strsplit(pairs[i], '='))
		argument_list[members[1]] = eval(parse(text=members[2]))
	}
	return( argument_list)

}

load_files_by_factors <- function(data, column_names, path_column, header ){
	all_data <- list()
	factor_columns <- match(column_names, names(data))
	factor_combinations <- unique(data[column_names])
	for(row in 1:nrow(factor_combinations)){
		combination <- as.vector(t((factor_combinations[row,]))) #extract row AND convert to vector
		check_combination <- data[factor_columns] == combination[col(data[factor_columns])]
		paths <- data[[path_column]][which(apply(check_combination, 1, sum) == length(combination))]
		name_list <- paste(combination, collapse='_')
		files <- list()
		count = 1
		for(file_path in paths){
			files[[count]] <- read.table(file_path, sep="\t", header=header)
			count = count + 1
		}
		all_data[[name_list]] <- files
	}
	return(all_data)
}


order_a_list_by_vector <- function(lst, field){
  length_vector <- c()

  for (i in 1:length(lst)){
    sublst <- lst[[i]]
    value <- sublst[[field]]
    length_vector[i] <- value
  } 
  ordered_lst <- lst[order(length_vector, decreasing=TRUE)] 

  return(ordered_lst)
}


produce_barplot <- function(column, title, ylab){
  data_frame <- summarySE(metric_table, measurevar=column, groupvars=c("Type"))
    
  plt <- ggplot(data_frame, aes(x=Type, y=get(column), fill=Type)) 
  plt <- plt + geom_bar(stat="identity")
  plt <- plt + geom_errorbar(aes(ymin=get(column)-sd, ymax=get(column)+sd),
                  width=.2,                    # Width of the error bars
                  position=position_dodge(.9)) #+
  plt <- plt + theme(axis.text.x = element_text(angle = 45, hjust = 1), 
                                axis.title.x=element_blank()
                                )
  plt <- plt + ylab(ylab)
  if(title != ''){
    plt <- plt + ggtitle(title) 
  }
  plt <- plt + theme(legend.position="none")
    
  return(plt)
}

delete_parental_terms<- function(df, subont){
  library(GOSim)
  library(GO.db)
  library(dplyr)
    
    
  setOntology(ont = subont)
  go_l <- getParents()
    
  initial_clusters <- length(unique(df$Cluster))
  
  clusters_l <- unique(df$Cluster)
  df1 <- data.frame()
  
  for(cluster in clusters_l){
    cluster_subset <- filter(df, Cluster == cluster)
    funsys_l <- cluster_subset$"Cell function"
    
    parents_l <- c()
    if(length(funsys_l) > 1){
      for(funsys in funsys_l){
        parents_l <- c(parents_l, go_l[[funsys]])
      }
      for(parent in parents_l){
        if(parent %in% funsys_l){
          cluster_subset <- (cluster_subset[!cluster_subset$"Cell function" == parent, ])
        }
      }
      df1 <- rbind(df1, cluster_subset)
    }else{
      df1 <- rbind(df1, cluster_subset)
    }
    
  }
  return(df1)
}

delete_child_terms<- function(df, subont){
  library(GOSim)
  library(GO.db)
  library(dplyr)
    
    
  setOntology(ont = subont)
  go_l <- getChildren()
    
  initial_clusters <- length(unique(df$Cluster))
  
  clusters_l <- unique(df$Cluster)
  df1 <- data.frame()
  
  for(cluster in clusters_l){
    cluster_subset <- filter(df, Cluster == cluster)
    funsys_l <- cluster_subset$Funsys
    
    child_l <- c()
    if(length(funsys_l) > 1){
      for(funsys in funsys_l){
        child_l <- c(child_l, go_l[[funsys]])
      }
      for(child in child_l){
        if(child %in% funsys_l){
          clusters_subset <- (cluster_subset[!cluster_subset$Funsys == child, ])
        }
      }
      df1 <- rbind(df1, cluster_subset)
    }else{
      df1 <- rbind(df1, cluster_subset)
    }
    
  }
  return(df1)
}


produce_density_plot <- function(data_table, values, net_names, net_types, x_scale = FALSE, x_lab, title, facet = FALSE){
        plt <- ggplot(data_table, aes(x=get(values))) + geom_density(aes(group=get(net_names), colour=get(net_types)))
        col <- c("firebrick1", "deepskyblue2")

        if (facet == TRUE){
          plt <- plt + facet_wrap( ~ groups, scales = "free")
        }
        if(x_scale == TRUE){
          plt <- plt + scale_x_continuous(limits = c(0, 1))
        }
        plt <- plt + ylim(0, 4.5)
        plt <- plt + xlab(x_lab)
        plt <- plt + ylab("Density")
        plt <- plt + ggtitle(title)
        plt <- plt + theme(legend.title=element_blank())
        plt <- plt + scale_fill_manual(values = col)
        plt <- plt + scale_color_manual(values = col)

        return(plt)
      }


########################################################################
## OPTPARSE
########################################################################

option_list <- list(
  make_option(c("-d", "--data"), type="character",
              help="Input path files comma separated"),
  make_option(c("-o","--output"), type="character",
              help="Output report"),
  make_option(c("-H","--headers"), type="character",
              help="Character comma separated using 't' for indicate the presence of header or 'f' when the file lacks of it"),
  make_option(c("-t","--template"), type = "character",
              help="Template file to use in the report rendering process"),
  make_option(c("-r","--read_file_parameters"), type = "character", default="comment.char='',sep=\"\t\"",
              help="Read table parameters. Default 'file_path, sep=\\t'")
)

opt <- parse_args(OptionParser(option_list=option_list))

########################################################################
## MAIN
########################################################################
file_paths <- strsplit(opt$data, ',')[[1]]
headers <- strsplit(opt$headers, ',')[[1]]
absolute_output_path <- getAbsolutePath(opt$output)
data <- load_files(file_paths, headers, opt$read_file_parameters)

#Set global options that apply to every chunk in the template
knitr::opts_chunk$set(echo = FALSE, warning=FALSE, message=FALSE)
#Generate report
rmarkdown::render(opt$template, output_file = absolute_output_path)


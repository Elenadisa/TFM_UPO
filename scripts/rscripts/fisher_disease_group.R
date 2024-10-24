#! /usr/bin/env Rscript

#############################################################################################################################################################################
#                                                          LIBRARIES                                                                                                          #
#############################################################################################################################################################################
require(dplyr)
require(optparse)

#########################################################################################################################################################################################################
#                                           OPTPARSE                                                    #
#########################################################################################################################################################################################################

option_list <- list(
  make_option(c("-i", "--input"), type="character",
              help="all disease input file"),
  make_option(c("-g", "--group_list"), type="character",
              help="input file with diseases list of the group"),
  make_option(c("-o", "--output"), type="character",
              help="output file with  significative phenotypes"),
  make_option(c("-O", "--output2"), type="character",
              help="output file with all phenotypes"),
  make_option(c("-p", "--output3"), type="character",
              help="output file with all phenotypes corrected p-value"),
  make_option(c("-d", "--output4"), type="character",
              help="orphanet disease subgroup df")
)

opt <- parse_args(OptionParser(option_list=option_list))

#########################################################################################################################################################################################################
#                                           METHODS                                                   #
#########################################################################################################################################################################################################

df <- read.table(opt$input, sep="\t", stringsAsFactors = FALSE, header = FALSE, quote = "")

disease_group <- read.table(opt$group_list, sep="\t", stringsAsFactors = FALSE, header = FALSE, quote = "")

all_diseases <- unique(df$V6)
group_disease <- unique(disease_group$V1)


group_df <- data.frame()
non_group_df <- data.frame()

for(disease in all_diseases){
  disease_df <- subset(df, V6 == disease)
  if(disease %in% group_disease){
    group_df <- rbind(group_df, disease_df)
  }else{
    non_group_df <- rbind(non_group_df, disease_df)
  }
}

nb_group_diseases <- length(unique(group_df$V6))
nb_non_group_diseases <- length(unique(non_group_df$V6))

write.table(group_df, opt$output4, sep="\t", col.names=FALSE, row.names=FALSE, quote = FALSE)


cat("Number group diseases", nb_group_diseases, "\n")
cat("Number non-group diseases", nb_non_group_diseases, "\n")

result_tb <- sapply(unique(df$V3), function(p) {
  p_group <- group_df[group_df$V3 %in% p, ]
  p_non_group <- non_group_df[non_group_df$V3 %in% p, ]

  cnt_tb <- matrix(c(length(unique(p_group$V6)),
                     length(unique(p_non_group$V6)),
                     nb_group_diseases - length(unique(p_group$V6)),
                     nb_non_group_diseases - length(unique(p_non_group$V6))),
                   ncol = 2, dimnames = list(c("Group", "non_group"), c("Present", "non_Present")))

  fish_res <- fisher.test(cnt_tb, alternative="greater")
  #print(p)
  #print(cnt_tb)

  return(c(p, length(unique(p_group$V6)), length(unique(p_non_group$V6)), fish_res$p.value))
})


result_tb <- t(result_tb)
result_df <- as.data.frame(result_tb)
colnames(result_df) <- c("HPO_ID", "Freq_group_diseases", "Freq_non_group_diseases", "P.Value")
tdf <- transform(result_df, P.Value = as.numeric(P.Value))
tdf$BH.pVal <- p.adjust(tdf$P.Value, method = "BH")
tdf <- tdf[order(tdf$P.Value,decreasing=FALSE),]
tdf$HPO_names <- unique(df$V4[match(tdf$HPO_ID, df$V3)])
tdf = tdf[ , c(1,6,2,3,4,5)]
result_df_bh_sig <- filter(tdf, BH.pVal <= 0.05)
result_df_sig <- filter(tdf, P.Value <= 0.05)

#sapply(tdf, mode)

write.table(tdf, opt$output2, sep="\t", col.names=TRUE, row.names=FALSE, quote = FALSE)
write.table(result_df_sig, opt$output, sep="\t", col.names=TRUE, row.names=FALSE, quote = FALSE)
write.table(result_df_bh_sig, opt$output3, sep="\t", col.names=TRUE, row.names=FALSE, quote = FALSE)
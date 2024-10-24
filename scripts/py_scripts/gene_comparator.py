#! /usr/bin/env python

def build_l(filename):
	file = open(filename)
	gene_l = []
	for line in file:
		line = line.rstrip("\n")
		if line not in gene_l:
			gene_l.append(line)

	return gene_l
	


##############################################################################################################################################
#															OPTPARSE
##############################################################################################################################################
import optparse

parser = optparse.OptionParser()

parser.add_option("-k", "--known_genes", dest="known_genes",
                  help="Input known genes file", metavar="FILE")

parser.add_option("-c", "--cluster_file", dest="cluster_file",
                  help="Input cluster file", metavar="FILE")

parser.add_option("-g", "--gene_column", dest="gene_col",
                  help="number of the column with gene ids", type='int')

parser.add_option("-o", "--output_file", dest="output_file",
                  help="output file", metavar="FILE")

(options, args) = parser.parse_args()

###############################################################################################################################################
# 															MAIN
###############################################################################################################################################
output_file = open(options.output_file, 'w')
output_file1 = open("genes_in_clusters.txt", 'w')

known_gene_l = build_l(options.known_genes)
print("Number of known genes"+ "\t" + str(len(known_gene_l)))

obtained_genes_l = []
cluster_file = open(options.cluster_file)


for line in cluster_file:
	line = line.rstrip("\n")
	fields = line.split("\t")
	gene_col = fields[options.gene_col]
	gene_l = gene_col.split(", ")
	for gene in gene_l:
		if gene not in obtained_genes_l:
			obtained_genes_l.append(gene)

while("" in obtained_genes_l):
    obtained_genes_l.remove("")

print("Number genes in clusters" + "\t" + str(len(obtained_genes_l)))
for gene in obtained_genes_l:
	output_file1.write("".join(gene) + "\n")

common_genes = set(known_gene_l).intersection(set(obtained_genes_l))
print("Number of common genes" + "\t" + str(len(common_genes)))
for gene in common_genes:
	output_file.write("".join(gene) + "\n")


only_in_known = set(known_gene_l).difference(set(obtained_genes_l))
print("Number of known genes not predicted" + "\t" + str(len(only_in_known)))

unknown_genes = set(obtained_genes_l).difference(set(known_gene_l))
print("Number of unknown genes" + "\t" + str(len(unknown_genes)))
print(unknown_genes)
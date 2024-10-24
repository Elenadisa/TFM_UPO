#! /usr/bin/env python

#import numpy
import functions as fn

def build_clusters_dictionary(filename, hpo1_col, hpo2_col, id_col, key):
	dictionary = {}
	file = open(filename)
	if key == "cluster":
		for line in file:
			line = line.rstrip("\n")
			fields = line.split("\t")
			hpo1 = fields[hpo1_col]
			hpo2 = fields[hpo2_col]
			value = hpo1 + "-" + hpo2
			id_value = fields[id_col]
			
			if id_value not in dictionary:
				dictionary[id_value] = [value]
			else :
				if value not in dictionary[id_value]:
					dictionary[id_value].append(value)

	elif key == "hpo":
		for line in file:
			line = line.rstrip("\n")
			fields = line.split("\t")
			hpo1 = fields[hpo1_col]
			hpo2 = fields[hpo2_col]
			id_value = hpo1 + "-" + hpo2
			value = fields[id_col]
			
			if id_value not in dictionary:
				dictionary[id_value] = [value]
			else :
				if value not in dictionary[id_value]:
					dictionary[id_value].append(value)

	return dictionary

def load_pair_files(filename, key_col, value_col):
	dictionary = {}
	file = open(filename)
	
	for line in file:
		line = line.rstrip("\n")
		fields = line.split("\t")
		key_id = fields[key_col]
		value = fields[value_col]
		
			
		if key_id not in dictionary:
			dictionary[key_id] = [value]
		else :
			if value not in dictionary[key_id]:
				dictionary[key_id].append(value)

	return dictionary

def build_pairs_gene_system_dictionary(filename, hpo1_col, hpo2_col, system_col, gene_col):
	dictionary = {}
	file = open(filename)
	for line in file:
		line = line.rstrip("\n")
		fields = line.split("\t")
		hpo1 = fields[hpo1_col]
		hpo2 = fields[hpo2_col]
		system = fields[system_col]
		genes = fields[gene_col]
		gene_l = genes.split("/")
		key = hpo1 + "-" + hpo1 + "/" + system

		if key not in dictionary:
			dictionary[key] = []
			for gene in gene_l:
				dictionary[key].append(gene)
		else:
			for gene in gene_l:
				if gene not in dictionary[key]:
					dictionary[key].append(gene)

	return dictionary



########################################################################################################################################
#														OPTPARSE
########################################################################################################################################
import optparse

parser=optparse.OptionParser()

parser.add_option("-c", "--cluster_file", dest="cluster_file_for_cytoscape", 
                  help="clustering.R output", metavar="FILE")
parser.add_option("-A", "--hpo1_cytoscape", dest="hpo1_cytoscape", 
                  help="column which have hpo 1 in cytoscape file", type='int')
parser.add_option("-a", "--hpo_2_cytoscape", dest="hpo2_cytoscape", 
                  help="column which have hpo 2 in cytoscape file", type='int')
parser.add_option("-x", "--cluster_id", dest="cluster_id", 
                  help="column which have cluster id in cytoscape file", type='int')


parser.add_option("-s", "--single enrichment file", dest="single_file", 
				  help="Single Enrichment dictionary", metavar="FILE")
parser.add_option("-E", "--hpo_single_enrichment", dest="hpo_single", 
                  help="column which have hpo ", type='int')
parser.add_option("-e", "--hpo_pathways_single", dest="pathway_single", 
                  help="column which have pathways ", type='int')
parser.add_option("-n", "--pathways_name", dest="pathway_name", 
                  help="column which have pathways names", type='int')
parser.add_option("-G", "--gene1_col", dest="gene_single", 
                  help="column which have genes col", type='int')

parser.add_option("-t", "--threshold", dest="threshold", 
                  help="threshold", type='int')

(options, arg) = parser.parse_args()

#######################################################################################################################################
#														MAIN
#######################################################################################################################################

cluster_dictionary = build_clusters_dictionary(options.cluster_file_for_cytoscape, options.hpo1_cytoscape, options.hpo2_cytoscape, options.cluster_id, key="cluster")
#print(cluster_dictionary)
single_pathways_dictionary = load_pair_files(options.single_file, options.hpo_single, options.pathway_single)

function2name_dict = load_pair_files(options.single_file, options.pathway_single, options.pathway_name)

single_hpo2function2gene = fn.build_double_dictionary(options.single_file, options.hpo_single, options.pathway_single, options.gene_single)

for cluster, HPO_pairs in cluster_dictionary.items():
	hpo2system_dictionary = dict()
	for hpos in HPO_pairs:
		pair = hpos.split("-")
		for node in pair:
			#single phenotype and pair have systems
			if node in single_pathways_dictionary:
				systems_l = set(single_pathways_dictionary[node])
				#print(cluster, hpos, node, systems_l, "both")
				if node not in hpo2system_dictionary:
					hpo2system_dictionary[node] = []
					for system in systems_l:
						hpo2system_dictionary[node].append(system)
				else:
					for system in systems_l:
						if system not in hpo2system_dictionary[node]:
							hpo2system_dictionary[node].append(system)

			
			elif node not in single_pathways_dictionary:
				if node not in hpo2system_dictionary:
					hpo2system_dictionary[node] = []

	#print(cluster, hpo2system_dictionary)
	all_keys = list(hpo2system_dictionary.keys())
	all_values = list(hpo2system_dictionary.values())
	values = sum(all_values, [])
	unique_values = set(values)
	for element in unique_values:
		times = values.count(element)
		coherence_score = (times * 100) / len(all_keys)
		#print(len(all_keys), element, times)
		if coherence_score >= options.threshold:		
			gene_l = []
			for phen in all_keys:
				if phen+"/"+element in single_hpo2function2gene:
					gene_l.append(single_hpo2function2gene[phen+"/"+element])

			print(cluster + "\t" + element + "\t" + ",".join(function2name_dict[element]) + "\t" + str(coherence_score) + "\t" + ",".join(set(sum(gene_l, []))))
	
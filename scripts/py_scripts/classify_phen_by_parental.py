#! /usr/bin/env python
##############################################################################################################################################
#															METHODS
##############################################################################################################################################
def obtain_child_terms(filename):
	file = open(filename)
	parent_child_dict = {}

	for line in file:
		line = line.rstrip("\n")
		fields = line.split(": ")
		if fields[0] == "id":
			term_name = fields[1]
		elif fields[0] == "is_a":
			parent, name = fields[1].split(" ! ")
			if parent not in parent_child_dict:
				parent_child_dict[parent] = []
				parent_child_dict[parent].append(term_name)
			else:
				parent_child_dict[parent].append(term_name)


	return parent_child_dict





##############################################################################################################################################
#															OPTPARSE
##############################################################################################################################################


import optparse
parser = optparse.OptionParser()
parser.add_option("-o", "--hpo_obo", dest="hpo_obo",
                  help="Input file hpo obo", metavar="FILE")
parser.add_option("-t", "--term", dest="parental_term",
                  help="parental term", metavar="FILE")
parser.add_option("-p", "--phenotype_file", dest="phenotype_file",
                  help="phenotype_file", metavar="FILE")

(options, args) = parser.parse_args()

###############################################################################################################################################
# 															MAIN
###############################################################################################################################################
parent_child_dict = obtain_child_terms(options.hpo_obo)


if options.parental_term in parent_child_dict:
	query_childs_list = parent_child_dict[options.parental_term]
	new_terms = query_childs_list.copy()
else:
	query_childs_list = []
	new_terms = []

while len(new_terms) != 0:
	new_list = [] #list to store child terms

	for term in new_terms:
		if term in parent_child_dict:
			query_childs_list.extend(parent_child_dict[term])
			new_list.extend(parent_child_dict[term])
			
	new_terms = new_list.copy()

final_child_l = set(query_childs_list)

phenotype_file = open(options.phenotype_file)

for line in phenotype_file:
	line = line.rstrip("\n")
	phen_id, phen_name, pvalue = line.split("\t")
	if phen_id in final_child_l or phen_id == options.parental_term:
		print(line)
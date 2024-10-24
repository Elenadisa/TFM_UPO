#! /usr/bin/env python

def build_dict(filename):
	file = open(filename)
	cluster_dict = {}

	for line in file:
		line = line.rstrip("\n")
		line = line.rstrip(" ")
		cluster, phen_str = line.split("\t")
		phen_l = phen_str.split(",")


		if cluster not in cluster_dict:
			cluster_dict[cluster] = []
			for phen in phen_l:
				cluster_dict[cluster].append(phen)
			

	return(cluster_dict)

##############################################################################################################################################
#															OPTPARSE
##############################################################################################################################################
import optparse
parser = optparse.OptionParser()
parser.add_option("-c", "--clique_file", dest="clique_file",
                  help="clique", metavar="FILE")

(options, args) = parser.parse_args()

###############################################################################################################################################
# 															MAIN
###############################################################################################################################################

cluster_dict = build_dict(options.clique_file)

for cluster, phen_l in cluster_dict.items():
	for phen in phen_l:
		print(phen + "\t" + cluster)
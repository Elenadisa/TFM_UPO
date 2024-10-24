#! /usr/bin/env python

from itertools import combinations

#########################################################################################################################################
#														OPTPARSE     																	#
#########################################################################################################################################
import optparse

parser=optparse.OptionParser()

parser.add_option("-i", "--input_file", dest="input_file", 
                  help="file with clique id and the list of phenotypes", metavar="FILE")
(options, arg) = parser.parse_args()

#########################################################################################################################################
#														MAIN																			#
#########################################################################################################################################
file = open(options.input_file)

for line in file:
	line = line.rstrip("\n")
	line = line.rstrip(" ")
	clique_id, phen_str = line.split("\t")
	phen_l = phen_str.split(",")
	pairs_l = list(combinations(phen_l, 2))
	#print(phen_str)
	
	for pair in pairs_l:
		phen1 = pair[0]
		phen2 = pair[1]
		print(phen1 + "\t" + phen2 + "\t" + clique_id)


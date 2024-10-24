#! /usr/bin/env python

##############################################################################################################################################
#															METHODS
##############################################################################################################################################
def load_disease_file(filename, key_col_number, value_col_number):
	dictionary = {}
	file = open(filename).readlines()[1:]
	
	for line in file:
		line = line.rstrip("\n")
		fields = line.split("\t")
		key = fields[key_col_number]
		value = fields[value_col_number]

		if key not in dictionary:
			dictionary[key] = [value]
		else :
			dictionary[key].append(value)

	return dictionary



##############################################################################################################################################
#															OPTPARSE
##############################################################################################################################################
import optparse

parser = optparse.OptionParser()

parser.add_option("-d", "--diseases file", dest="diseases",
                  help="Input diseases file", metavar="FILE")
parser.add_option("-n", "--profiles", dest="profile",
                  help="Diseases patterns", metavar="FILE")
parser.add_option("-b", "--key_column_profile_id", dest="profile_id",
                  help="Diseases ids", type='int')
parser.add_option("-y", "--value_column_profile", dest="profile_value",
                  help="profile_value", type='int')



(options, args) = parser.parse_args()

###############################################################################################################################################
# 															MAIN
###############################################################################################################################################

profile_dictionary = load_disease_file(options.profile, options.profile_id, options.profile_value)

file = open(options.diseases)
output = open('test.txt', 'w')
for line in file:
	line = line.rstrip("\n")
	fields = line.split("\t")
	disease_id = fields[0]
	
	if disease_id in profile_dictionary:
		for HPO in profile_dictionary[disease_id]:
			print(disease_id + "\t" +  HPO)
	else:
		output.write(disease_id + "\t" + HPO + "\n")

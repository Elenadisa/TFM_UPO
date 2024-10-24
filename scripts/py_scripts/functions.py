
def build_double_dictionary(filename, key1_col, key2_col, value_col):
	"""Build a dictionary with two merge keys"""
	dictionary = {}
	file = open(filename)
	for line in file:
		line = line.rstrip("\n")
		fields = line.split("\t")
		key1 = fields[key1_col]
		key2 = fields[key2_col]
		value = fields[value_col]
		gene_l = value.split("/")
		key = key1 + "/" + key2

		if key not in dictionary:
			dictionary[key] = []
			for gene in gene_l:
				dictionary[key].append(gene)
		else:
			for gene in gene_l:
				if gene not in dictionary[key]:
					dictionary[key].append(gene)

	return dictionary


def build_dictionary(filename, key_col_number, value_col_number):
	"""Build a dictionary from a file"""
	dictionary = {}
	file = open(filename)
	
	for line in file:
		line = line.rstrip("\n")
		fields = line.split("\t")
		key = fields[key_col_number]
		value = fields[value_col_number]

		if key not in dictionary:
			dictionary[key] = [value]
		else :
			if value not in dictionary[key]:
				dictionary[key].append(value)

	return dictionary


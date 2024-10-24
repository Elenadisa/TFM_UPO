#! /usr/bin/env python
import pandas as pd

##############################################################################################################################################
#															OPTPARSE
##############################################################################################################################################
import optparse
parser = optparse.OptionParser()
parser.add_option("-i", "--input_file", dest="input_file",
                  help="Input file metrics", metavar="FILE")
parser.add_option("-o", "--output_file", dest="output_file",
                  help="Output file", metavar="FILE")


(options, args) = parser.parse_args()

###############################################################################################################################################
# 															MAIN
###############################################################################################################################################

df = pd.read_csv(options.input_file, sep="\t", header=None)
df1 = df.rename(columns={0: "Name", 1: "Type", 2: "Metric", 3: "Value"})
reshaped_df = df1.pivot_table(index=['Name', "Type"], columns='Metric', values='Value', aggfunc=lambda x: ' '.join(str(v) for v in x)).reset_index().rename_axis(None)
reshaped_df.to_csv(options.output_file, index=False, header=True,sep='\t')
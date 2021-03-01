##############
# Author: Ben Joris
# Created: September 11th, 2020
# Purpose: Turn files generated by reassembly_mapping_data.sh into single tsv
##############

import glob
import collections
import os
import pandas

master_dict=collections.defaultdict(dict)

for file in glob.glob("../pop_mapping_data/sorted*.txt"):
    sample_name=os.path.basename(file).split(".")[0].rsplit("_",1)[1]
    with open(file) as fh:
        for line in fh:
            master_dict[sample_name][line.split("\t")[0]]=line.split("\t")[2]

df=pandas.DataFrame(master_dict)
df.to_csv("../pop_mapping_data/aggregated.tsv", sep="\t", na_rep="0")
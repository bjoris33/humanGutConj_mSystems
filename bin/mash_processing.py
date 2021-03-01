##############
# Author: Ben Joris
# Created: September 1st, 2020
# Purpose: take raw mash output and convert into a dataframe
##############

import pandas
import collections

curfh=""
curdict={}
fulldict=collections.defaultdict(dict)
with open("mash_results.txt") as fh:
    for line in fh:
        if "Sketching ../ani_input/all.fasta" in line:
            continue
        else:
            fulldict[line.strip().split("\t")[1]][line.strip().split("\t")[0]]=float(line.split("\t")[4].split("/")[0])/float(line.split("\t")[4].split("/")[1])

df=pandas.DataFrame(fulldict)
df.to_csv("mash_table.tsv", sep="\t")

##############
# Author: Ben Joris
# Created: January 18th, 2021
# Purpose: mob_typer outputs a large number of files that are all one line tables, would make sense to combine them into one large file
##############

import pandas
import glob

dfMaster=pandas.DataFrame()

for file in glob.glob("../mob_typer/*.txt"):
    tempdf=pandas.read_csv(file, sep="\t",header=0)
    dfMaster=pandas.concat([dfMaster,tempdf])

dfMaster.to_csv("../mob_typer/combined.tsv", sep="\t",na_rep=0)
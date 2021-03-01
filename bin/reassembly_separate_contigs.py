##############
# Author: Ben Joris
# Created: June 30th, 2020
# Purpose: from an aggregated fasta of the conjutive contigs, separate into individual fasta files
##############

curfh=""

with open("../reassembly/contigs.fa") as oldfh:
    for line in oldfh:
        if ">" in line:
            curfh=line[1:].strip()
        with open("../reassembly_contigs/"+curfh+".fa","a") as newfh:
            newfh.write(line)

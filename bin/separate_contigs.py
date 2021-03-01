##############
# Author: Ben Joris
# Created: January 18th, 2021
# Purpose: take multifasta and separate, need to write reusable python script for this
##############



with open("../genome_set_conj/contigs.fa") as fh:
    for line in fh:
        if ">" in line:
            fName="../genome_set_contigs/"+line.strip()[1:]+".fa"
            with open(fName,"w") as newfh:
                newfh.write(line)
        else:
            with open(fName,"a") as newfh:
                newfh.write(line)            
                
##############
# Author: Tyler Browne, edited by Ben Joris (June 2020)
# Created: September 2019
# Purpose: outputs annotations from all contigs to totalGenes.txt
    # one annotation per line
##############

import sys
import os

inname = os.path.basename(sys.argv[1])

fileinput = open("../conjugative_contigs/" + inname, "r")     #reads through all *.txt files to pull out gene names
fileoutput = open("../summary_data/totalGenes.txt", "a")

for line in fileinput:

    if line != "\n" and line != '\n':
        temp = line.split('\t')
        fileoutput.write(temp[1] + '\n')

fileinput.close()
fileoutput.close()

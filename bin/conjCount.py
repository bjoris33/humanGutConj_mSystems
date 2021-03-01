##############
# Author: Tyler Browne, edited by Ben Joris (June 2020)
# Created: September 2019
# Purpose: counts the frequecies of relaxases and t4ss/t4cp proteins
##############

import sys
import os

# Takes in the filename given from conjCounts.sh
inname = os.path.basename(sys.argv[1])

# Opens the file from the argument variable (a file from gutDB/plasmids)
fileinput = open("../conjugative_contigs/" + inname, "r")     #reads through all *.txt files in gutDB/plasmids to pull out gene names
# Opens the output file to append to with conjugative machinery counts
fileoutput = open("../summary_data/conjCountTemp.txt", "a")

relaxases = 0
typeIVs = 0
test = 0

# Reads through the lines in to the input file and counts the number of conjugative machinery annotations
for line in fileinput:

        temp = line.split('\t')
        temp2 = temp[0].rsplit("_",1)
        if int(temp2[1]) < test + 1:
                if relaxases > 0 and typeIVs > 0:
                        #print(name + "\tRelax" + "\t" + str(relaxases) + "\tT4SS" + "\t" + str(typeIVs) + "\t" + inname.strip(".txt") + "\n")
                        fileoutput.write(name + "\tRelax" + "\t" + str(relaxases) + "\tT4SS" + "\t" + str(typeIVs) + "\t" + inname.strip(".txt") + "\n")
                relaxases = 0
                typeIVs = 0
        name = temp2[0]

        test = int(temp2[1])

        if "relaxase" in line or "Relaxase" in line or "mobilization" in line or "Mobilization" in line or "mobilisation" in line or "Mobilisation" in line:
                relaxases = relaxases + 1

        if "PilV" in line or "pilV" in line or "VirB4" in line or "virB4" in line or "VirD4" in line or "virB4" in line or "conjugal" in line or "Conjugal" in line or "TraB" in line or "traB" in line or (("Type" in line or "type" in line) and ("IV" in line or "iv" in line) and ("Secret" in line or "secret" in line)):
                typeIVs = typeIVs + 1

# The revised annotations removed some of the relax/T4SS annoations so this double checks that one of each exists, then writes the resulting info to the output file
if relaxases > 0 and typeIVs > 0:
        #print(name + "\tRelax" + "\t" + str(relaxases) + "\tT4SS" + "\t" + str(typeIVs) + "\t" + inname.strip(".txt") + "\n")
        fileoutput.write(name + "\tRelax" + "\t" + str(relaxases) + "\tT4SS" + "\t" + str(typeIVs) + "\t" + inname.strip(".txt") + "\n")

fileinput.close()
fileoutput.close()

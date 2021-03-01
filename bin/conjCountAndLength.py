##############
# Author: Tyler Browne, edited by Ben Joris (June 2020)
# Created: September 2019
# Purpose: adds length to data from conjCount.txt, writes to conjCountsAndLengths.txt
##############

import sys
import os

# Opens the file containing names and conjugative machinery counts for contigs from gutDB/plasmids/
countInput = open("../summary_data/conjCount.txt", "r")
# Opens the file containing names and lengths for contigs from gutDB/plasmids/
lengthsInput = open("../summary_data/contiglengths.txt", "r")
# Creates a new file to place the concatinated infomation including names, conjugative machinery counts, and contig lengths
outfile = open("../summary_data/conjCountsAndLengths.txt", "w+")

lengthsDict = {}

# Places lengths info into a dictionary by name
for lenInput in lengthsInput:
    lenInput2 = lenInput.split("\t")
    #print(lenInput2[0] + "\t" + lenInput2[1])
    lengthsDict[lenInput2[0]] = lenInput2[1]    #name points to the length listed in the lengths file

# Uses the length dictionary to concatinate info into the conjCountsAndLengths.txt file
for line in countInput:
    line2 = line.split("\t")
    #print(lengthsDict[line2[0]])
    #print(line.strip("\n") + "\tLength\t" + lengthsDict[line2[0]])
    #outfile.write("Length\t" + lengthsDict[line2[0]].strip("\n") + "\t" + line.strip("\n") + "\n")
    outfile.write("Length\t" + lengthsDict[line2[0]].strip("\n") + "\t" + line2[1] + "\t" + line2[2] + "\t" + line2[3] + "\t" + line2[4].strip("\n") + "\t" + line2[5].strip("\n")  + "\t" + line2[0] + "\n")

countInput.close()
lengthsInput.close()
outfile.close()

##############
# Author: Tyler Browne, edited by Ben Joris (June 2020)
# Created: September 2019
# Purpose: counts and sorts the data gathered by conjCount.py, writes to conjCount.txt
##############

import sys
import os

# Opens the conjugative machinery counts temporary file to be sorted
fileinput = open("../summary_data/conjCountTemp.txt", "r")
fileoutput = open("../summary_data/conjCount.txt", "w+")

diction = {}
counts = {}

# Places information into dictionaries to be sorted by conjugative machinery count
for line in fileinput:
    temp = line.split('\t')
    diction[temp[0]] = line.strip("\n")
    counts[temp[0]] = int(temp[2]) + int(temp[4])

# Sorts the conjugative machinery counts in the counts dictionary and writes to the outfile using the output dictionary
for item in sorted(counts.items(), key = lambda kv:(kv[1], kv[0]), reverse = True):
    fileoutput.write(diction[item[0]] + "\n")

fileinput.close()
fileoutput.close()

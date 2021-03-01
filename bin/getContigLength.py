##############
# Author: Tyler Browne, edited by Ben Joris (June 2020)
# Created: September 2019
# Purpose: takes the DNA sequence files and calculates the lengths of the contigs
##############

import sys
import os

inname = os.path.basename(sys.argv[1])

fileinput = open("../conjugative_contigs/" + inname, "r")
fileoutput = open("../summary_data/contiglengths.txt", "a")

flag = False
length = -1
name = ""
count = 0

for line in fileinput:

    if line[0] == '>':
        if length != -1:
            fileoutput.write(name + '\t' + str(length) + '\n')
        temp = line.lstrip(">")
        name = temp.strip('\n')
        length = 0

    else:
	length = length + len(line.strip('\n'))

if length != -1:
    fileoutput.write(name + '\t' + str(length) + '\n')

fileinput.close()
fileoutput.close()

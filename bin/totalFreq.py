##############
# Author: Tyler Browne, edited by Ben Joris (June 2020)
# Created: September 2019
# Purpose: takes annotations from totalGenes.txt, and counts the frequencies of annotations
##############


import collections

outfile = open("../summary_data/geneFreq.txt", "w+")

with open('../summary_data/totalGenes.txt') as infile:
    counts = collections.Counter(l.strip() for l in infile)
for line, count in counts.most_common():
    #print count, line
    outfile.write(str(count) + "\t" + line + "\n")

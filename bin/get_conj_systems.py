'''
Author: Ben Joris
Created: October 23rd, 2019
Purpose: Write new contigs fasta with only the scaffolds that have relaxase, t4cp, AND t4ss hmm hits
'''
from pathlib import Path
import sys

#generate list of contigs containing hits of relaxase HMMs
rellist=[]
with open(sys.argv[0]) as relfh:
    for line in relfh:
        if ">" in line:
            rellist.append(line.split("|")[3].split(":")[1])
#generate list of contigs containing hits of secretion system HMMs
seclist=[]
with open(sys.argv[1]) as secfh:
    for line in secfh:
        if ">" in line:
            seclist.append(line.split("|")[3].split(":")[1])
#generate list of contigs containing hits of secretion system HMMs
couplist=[]
with open(sys.argv[2]) as coupfh:
    for line in coupfh:
        if ">" in line:
            couplist.append(line.split("|")[3].split(":")[1])

outputflag=False

with open(sys.argv[3]) as oldfa:
    with open(sys.argv[4],"a") as newfa:
        pass
    for line in oldfa:
        if ">" in line:
            outputflag=False
            if line[1:].strip() in rellist and line[1:].strip() in seclist and line[1:].strip() in couplist:
                outputflag=True
        if outputflag is True:
            with open(sys.argv[4],"a") as newfa:
                newfa.write(line)

##############
# Author: Tyler Browne, edited by Ben Joris (June 2020)
# Created: September 2019
# Purpose: takes the .m8 output (renamed as .faa.contigs) and finds the most common annotation for a ORF
    # outputs to a .txt file
##############

import sys
import os

inname = os.path.basename(sys.argv[1])
fileinput = open("../conjugative_contigs/"+inname, "r")     # Takes in files of the format *.faa.m8
countDict = {}
qualityDict = {}
nameDict = {}
final = {}

for line in fileinput:
    line2 = line.split('\t')
    # line2[0] == what the name of the orf is
    if line2[0] not in countDict:
        innerCountDict = {}
        countDict[line2[0]] = innerCountDict
        innerQualityDict = {}
        qualityDict[line2[0]] = innerQualityDict
        innerNameDict = {}
        nameDict[line2[0]] = innerNameDict
    line3 = line2[1].split(':',1)
    line4 = line3[1].split("n=")
    innerCDict = countDict[line2[0]]
    innerQDict = qualityDict[line2[0]]
    innerNDict = nameDict[line2[0]]
    if "hypothetical" in line4[0] or "Hypothetical" in line4[0] or "unknown" in line4[0] or "Unknown" in line4[0] or "DUF" in line4[0] or "duf" in line4[0] or "UNKNOWN" in line4[0] or "Uncharacterized" in line4[0] or "uncharacterized" in line4[0]:
        line4[0] = "DISREGARD:"
    if line4[0] in innerCDict:
        innerCDict[line4[0]] = int(innerCDict[line4[0]]) + 1
        if float(line2[2]) > float(innerQDict[line4[0]]):
            innerQDict[line4[0]] = float(line2[2])
            innerNDict[line4[0]] = line
    else:
        innerCDict[line4[0]] = 1
        innerQDict[line4[0]] = line2[2]
        innerNDict[line4[0]] = line
for orf in countDict:
    inCDict = countDict[orf]
    inQDict = qualityDict[orf]
    maxCount = 0
    quality = 0.0
    bestAnn = " "

    for annotation in inCDict:
        if (int(inCDict[annotation]) > maxCount) and annotation != "DISREGARD:":
            maxCount = int(inCDict[annotation])
            quality = inQDict[annotation]
            bestAnn = annotation

        elif (int(inCDict[annotation]) == maxCount) and annotation != "DISREGARD:":
            if inQDict[annotation] > quality:
                maxCount = int(inCDict[annotation])
                quality = inQDict[annotation]
                bestAnn = annotation

    if bestAnn == " ":
        final[orf] = "NA:"
    else:
        final[orf] = bestAnn


fileinput.close()
fileinput2 = open("../conjugative_contigs/" + inname, "r")     # Takes in files of the format *.faa.m8
tester = " "
unknown = False
outfile = open("../conjugative_contigs/" + inname.strip(".faa.contigs") + ".txt", "w+")
for line in fileinput2:
    # MAP USING THE ORF AND BESTANN NAMING STUFF FROM THE NAME DICTIONARIES TO GET THE FULL LINE ANNOTATION
    # MAKE SURE TO SUB-IN THE "NA" FOR THE ANNOTATIONS WITH UNKNOWN/ETC...
    line2 = line.split('\t')
    line3 = line2[1].split(':',1)
    line4 = line3[1].split("n=")
    # line2[0] == what the name of the orf is
    # line4[0] == what the annotation for the orf is
    # line2[2] == what the quality for annotation of the orf is

    if line2[0] != tester:
        tester = line2[0]
        unknown = False

    annotation = final[line2[0]]
    innerName = nameDict[line2[0]]

    if annotation == "NA:":
        if unknown == False:
            outfile.write(line2[0] + "\tNA\tNA\n")
        unknown = True

    if line4[0] == annotation and unknown == False:
        if line == innerName[annotation]:
            outfile.write(line2[0] + "\t" + annotation.strip(':') + "\t" + line2[2] + "\n")

fileinput2.close()
outfile.close()

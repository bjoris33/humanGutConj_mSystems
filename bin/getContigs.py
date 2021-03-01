##############
# Author: Tyler Browne, edited by Ben Joris (June 2020)
# Created: Sept 2019
# Purpose: Scans through the annotations and searches for annotations for relaxes
    # Then searches for annotations for conjugal transfer proteins (both coupling and secretion proteins)
    # Outputs DNA and protein sequences for identified contigs as well as the annotations
##############

import sys
import os

inname = os.path.basename(sys.argv[1])

# For reference: contig[0] contains the generic contig name without the specific read/#/whatever
#                name[0] contains the contig WITH the specific read which has the protein of interest


if "combined" not in inname:
    fileinput = open("../diamond_output/" + inname.strip(".fa") + ".m8", "r")	  # NEEDS TO TAKE IN *.fa FILES, but CONVERT TO .faa.m8 AS YOU NEED THE ORFs FROM .faa FILES LATER, IF CONTIGS FOUND
    matchFound = False
    mainmatch = []
    diction = {}        # NEED DICTIONARY FOR RELAXASE COUNT AND FOR TYPE IV SECRETION COUNT
    relaxCount = {}
    typeivCount = {}
    for x in fileinput:
        if "relaxase" in x or "Relaxase" in x or "mobilization" in x or "Mobilization" in x or "mobilisation" in x or "Mobilisation" in x:
            name = x.split('\t')
            contig = name[0].rsplit('_', 1)
            if contig[0] in diction:
                relaxCount[contig[0]] = "2"
            else:
                diction[contig[0]] = name[0]
                relaxCount[contig[0]] = "1"
    fileinput.close()
    fileinput2 = open("../diamond_output/" + inname.strip(".fa") + ".m8", "r")	   # NEEDS TO TAKE IN *.fa FILES, but CONVERT TO .faa.m8 AS YOU NEED THE ORFs FROM .faa FILES LATER, IF CONTIGS FOUND
    #fileoutput.write("## Contigs Found\n")
    for x in fileinput2:
        if "PilV" in x or "pilV" in x or "VirB4" in x or "virB4" in x or "VirD4" in x or "virB4" in x or "conjugal" in x or "Conjugal" in x or "TraB" in x or "traB" in x or (("Type" in x or "type" in x) and ("IV" in x or "iv" in x) and ("Secret" in x or "secret" in x)):
            name = x.split('\t')
            contig = name[0].rsplit('_', 1)
            if contig[0] in diction and relaxCount[contig[0]] == "2":
                if contig[0] in typeivCount:
                    if matchFound == False:
                        fileoutput = open("../conjugative_contigs/" + inname + "a.contigs", "w+")
                        #fileoutput.write("## Contigs Found\n")
                    if contig[0] not in mainmatch:
                        mainmatch.append(contig[0])
                        #fileoutput.write(contig[0] + "\n")
                    matchFound = True
                else:
                    typeivCount[contig[0]] = "1"
    fileinput2.close()
    if matchFound == True:
        fileinput3 = open("../diamond_output/" + inname.strip(".fa") + ".m8", "r")      # NEEDS TO TAKE IN *.faa FILES, but CONVERT TO .faa.m8 AS YOU NEED THE ORFs FROM .faa FILES LATER, IF CONTIGS FOUND
        for x in fileinput3:
            name = x.split('\t')
            contig = name[0].rsplit('_', 1)
            if contig[0] in mainmatch:
                fileoutput.write(x)#"\n" + name[1].strip('\n'))
        # * * * * * * * * #
        fileinput3.close()
        fileoutput.close()
        # THIS IS WHERE YOU ANNOTATE BASED UPON THE CONTIGS FOUND
        orfsInput = open("../prodigal_output/" + inname + "a", "r")
        orfsOutput = open ("../conjugative_contigs/" + inname + "a.orfs.fa", "w+")
        flag = False
        count = 0
        for line in orfsInput:
            if line[0] == '>':
                bigName = line.split(" ")
                contigMid = bigName[0].rsplit('_', 1)
                contName = contigMid[0].lstrip('>')
                if contName in mainmatch:
                    flag = True
                else:
                    flag = False
            if flag == True:
                if line != "\n":
                    orfsOutput.write(line)
        orfsInput.close()
        orfsOutput.close()
        dnaInput = open("../genomes/" + inname, "r")
        dnaOutput = open("../conjugative_contigs/" + inname + ".DNA.fa", "w+")
        flag = False
        for line in dnaInput:
            if line[0] == '>':
                line2 = line.rstrip('\n')
                line3 = line2.lstrip('>')
                if line3 in mainmatch:
                    flag = True
                else:
                    flag = False
            if flag == True:
                if line != "\n":
                    dnaOutput.write(line)

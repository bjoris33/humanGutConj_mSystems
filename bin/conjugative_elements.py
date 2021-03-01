##############
# Author: Ben Joris
# Created: September 11th, 2019
    # Edited: July 27th, 2020
# Purpose: The sequences isolated in the plasmids folder contain a lot of information aside from the conjugative operonsself.
    # These extra data can add noise to the downstream analyses.
    # The goal of this program is to output the DNA sequence, protein sequence, and annotations for regions of the contigs with conjugative systems.
    # Utilizes the already created orf_tables that have summary information for the contigs generated.
##############

import glob
from collections import defaultdict

# debugcounter=0
for file in glob.glob("../annotation_tables/*refined.txt"):
    fname=file.rsplit("/",1)[1].rsplit("_",1)[0]
    print(fname)
    infolist=[]
    with open(file) as fh:
        for line in fh:
            if "N/A" not in line.split("\t")[13] and "function" not in line.split("\t")[13]:
                infolist.append((line.split("\t")[14],line.split("\t")[15],line.split("\t")[16],line.split("\t")[12]))
    if len(infolist) == 1:
        with open("../conjugative_contigs/"+fname+".txt") as annofh:
            for line in annofh:
                if infolist[0][0]+"_"+infolist[0][1]+"\t" in line:
                    with open("../conjugative_systems/annotations/"+fname+".txt", "a") as annonew:
                        annonew.write(line.split("\t")[0].rsplit("_",1)[0]+"_"+"1"+"_"+line.split("\t")[0].rsplit("_",1)[1]+"\t"+line.split("\t")[1]+"\n")
        with open("../conjugative_contigs/"+fname+".faa.orfs.fa") as aafh:
            proteinfound=False
            for line in aafh:
                if ">" in line:
                    proteinfound=False
                if infolist[0][0]+"_"+infolist[0][1]+" " in line:
                    proteinfound=True
                if proteinfound is True:
                    if ">" in line:
                        with open("../conjugative_systems/protein_sequences/"+fname+".faa.orfs.fa", "a") as aanew:
                            aanew.write(line.split(" ")[0].rsplit("_",1)[0]+"_"+"1"+"_"+line.split(" ")[0].rsplit("_",1)[1]+" "+line.split(" ",1)[1])
                    else:
                        with open("../conjugative_systems/protein_sequences/"+fname+".faa.orfs.fa", "a") as aanew:
                            aanew.write(line)
        with open("../conjugative_contigs/"+fname+".fa.DNA.fa") as dnafh:
            dnaheadfound=False
            dnastring=""
            for dna in dnafh:
                if ">" in dna:
                    dnaheadfound=False
                if infolist[0][0] in dna:
                    dnaheadfound=True
                    with open("../conjugative_systems/nucleotide_sequences/"+fname+".fa.DNA.fa", "a") as dnanew:
                        dnanew.write(dna.strip()+"_"+"1"+"\n")
                elif dnaheadfound is True:
                    dnastring=dnastring+dna.strip()
            operon=dnastring[int(infolist[0][2])-1:int(infolist[0][3])]
            with open("../conjugative_systems/nucleotide_sequences/"+fname+".fa.DNA.fa", "a") as dnanew:
                dnanew.write(operon)
    elif len(infolist) == 0:
        pass
    else:
        multiOperon=False
        multiContig=False
        recentOrf=0
        curContig=None
        for orf in infolist:
            if curContig is None:
                curContig=orf[0]
            elif orf[0] != curContig:
                multiContig=True
            if recentOrf == 0:
                recentOrf=int(orf[1])
            elif int(orf[1]) - recentOrf > 20:
                multiOperon=True
            recentOrf=int(orf[1])

###########################################

        if multiOperon or multiContig:
            if multiOperon and not multiContig:
                paramlist=[]
                orfstart=int(infolist[0][1])
                orfstop=0
                nucstart=int(infolist[0][2])-1
                nucstop=0
                contigname=infolist[0][0]
                prevOrf=int(infolist[0][1])
                for orf in infolist:
                    print(orf)
                    if int(orf[1]) - prevOrf > 20:
                        paramlist.append((orfstart,orfstop,nucstart,nucstop,contigname))
                        orfstart=int(orf[1])
                        orfstop=int(orf[1])
                        nucstart=int(orf[2])-1
                        nucstop=int(orf[3])
                    else:
                        orfstop=int(orf[1])
                        nucstop=int(orf[3])
                    prevOrf=int(orf[1])
                paramlist.append((orfstart,orfstop,nucstart,nucstop,contigname))
                print(paramlist)
                for i in range(0,len(paramlist)):
                    with open("../conjugative_contigs/"+fname+".txt") as annofh:
                        outputflag=False
                        for line in annofh:
                            if paramlist[i][4]+"_"+str(paramlist[i][0])+"\t" in line:
                                outputflag=True
                            if paramlist[i][4]+"_"+str(paramlist[i][1]+1) in line or paramlist[i][4]+"_"+str(paramlist[i][1]+2) in line or paramlist[i][4]+"_"+str(paramlist[i][1]+3) in line or paramlist[i][4]+"_"+str(paramlist[i][1]+4) in line or paramlist[i][4] not in line:
                                outputflag=False
                            if outputflag:
                                with open("../conjugative_systems/annotations/"+fname+".txt", "a") as annonew:
                                    annonew.write(line.split("\t")[0].rsplit("_",1)[0]+"_"+str(i+1)+"_"+line.split("\t")[0].rsplit("_",1)[1]+"\t"+line.split("\t")[1]+"\n")
                for i in range(0,len(paramlist)):
                    with open("../conjugative_contigs/"+fname+".faa.orfs.fa") as aafh:
                        outputflag=False
                        for line in aafh:
                            if paramlist[i][4]+"_"+str(paramlist[i][0])+" " in line:
                                outputflag=True
                            if paramlist[i][4]+"_"+str(paramlist[i][1]+1)+" " in line or (paramlist[i][4] not in line and ">" in line):
                                outputflag=False
                            if outputflag:
                                if ">" in line:
                                    with open("../conjugative_systems/protein_sequences/"+fname+".faa.orfs.fa", "a") as aanew:
                                        aanew.write(line.split(" ")[0].rsplit("_",1)[0]+"_"+str(i+1)+"_"+line.split(" ")[0].rsplit("_",1)[1]+" "+line.split(" ",1)[1])
                                else:
                                    with open("../conjugative_systems/protein_sequences/"+fname+".faa.orfs.fa", "a") as aanew:
                                        aanew.write(line)
                for i in range(0,len(paramlist)):
                    with open("../conjugative_contigs/"+fname+".fa.DNA.fa") as dnafh:
                        dnaheadfound=False
                        dnastring=""
                        for dna in dnafh:
                            if ">" in dna:
                                dnaheadfound=False
                            if ">"+contigname+"\n" in dna:
                                dnaheadfound=True
                                with open("../conjugative_systems/nucleotide_sequences/"+fname+".fa.DNA.fa", "a") as dnanew:
                                    dnanew.write(dna.strip()+"_"+str(i+1)+"\n")
                            elif dnaheadfound is True:
                                dnastring=dnastring+dna.strip()
                        operon=dnastring[int(paramlist[i][2]):int(paramlist[i][3])]
                        with open("../conjugative_systems/nucleotide_sequences/"+fname+".fa.DNA.fa", "a") as dnanew:
                            dnanew.write(operon+"\n")

            else:
                paramlist=[]
                orfstart=int(infolist[0][1])
                orfstop=0
                nucstart=int(infolist[0][2])-1
                nucstop=0
                contigname=infolist[0][0]
                prevOrf=int(infolist[0][1])
                for orf in infolist:
                    print(orf)
                    if orf[0] != contigname:
                        paramlist.append((orfstart,orfstop,nucstart,nucstop,contigname))
                        orfstart=int(orf[1])
                        orfstop=int(orf[1])
                        nucstart=int(orf[2])-1
                        nucstop=int(orf[3])
                        contigname=orf[0]
                    if int(orf[1]) - prevOrf > 20:
                        paramlist.append((orfstart,orfstop,nucstart,nucstop,contigname))
                        orfstart=int(orf[1])
                        orfstop=int(orf[1])
                        nucstart=int(orf[2])-1
                        nucstop=int(orf[3])
                    else:
                        orfstop=int(orf[1])
                        nucstop=int(orf[3])
                    prevOrf=int(orf[1])
                paramlist.append((orfstart,orfstop,nucstart,nucstop,contigname))
                print(paramlist)
                for i in range(0,len(paramlist)):
                    with open("../conjugative_contigs/"+fname+".txt") as annofh:
                        outputflag=False
                        for line in annofh:
                            if paramlist[i][4]+"_"+str(paramlist[i][0])+"\t" in line:
                                outputflag=True
                            if paramlist[i][4]+"_"+str(paramlist[i][1]+1) in line or paramlist[i][4]+"_"+str(paramlist[i][1]+2) in line or paramlist[i][4]+"_"+str(paramlist[i][1]+3) in line or paramlist[i][4]+"_"+str(paramlist[i][1]+4) in line or paramlist[i][4]+"_" not in line:
                                outputflag=False
                            if outputflag:
                                with open("../conjugative_systems/annotations/"+fname+".txt", "a") as annonew:
                                    annonew.write(line.split("\t")[0].rsplit("_",1)[0]+"_"+str(i+1)+"_"+line.split("\t")[0].rsplit("_",1)[1]+"\t"+line.split("\t")[1]+"\n")
                for i in range(0,len(paramlist)):
                    with open("../conjugative_contigs/"+fname+".faa.orfs.fa") as aafh:
                        outputflag=False
                        for line in aafh:
                            if paramlist[i][4]+"_"+str(paramlist[i][0])+" " in line:
                                outputflag=True
                            if paramlist[i][4]+"_"+str(paramlist[i][1]+1)+" " in line or (paramlist[i][4]+"_" not in line and ">" in line):
                                outputflag=False
                            if outputflag:
                                if ">" in line:
                                    with open("../conjugative_systems/protein_sequences/"+fname+".faa.orfs.fa", "a") as aanew:
                                        aanew.write(line.split(" ")[0].rsplit("_",1)[0]+"_"+str(i+1)+"_"+line.split(" ")[0].rsplit("_",1)[1]+" "+line.split(" ",1)[1])
                                else:
                                    with open("../conjugative_systems/protein_sequences/"+fname+".faa.orfs.fa", "a") as aanew:
                                        aanew.write(line)
                for i in range(0,len(paramlist)):
                    with open("../conjugative_contigs/"+fname+".fa.DNA.fa") as dnafh:
                        dnaheadfound=False
                        dnastring=""
                        for dna in dnafh:
                            if ">" in dna:
                                dnaheadfound=False
                            if ">"+paramlist[i][4]+"\n" in dna:
                                dnaheadfound=True
                                with open("../conjugative_systems/nucleotide_sequences/"+fname+".fa.DNA.fa", "a") as dnanew:
                                    dnanew.write(dna.strip()+"_"+str(i+1)+"\n")
                            elif dnaheadfound is True:
                                dnastring=dnastring+dna.strip()
                        operon=dnastring[int(paramlist[i][2]):int(paramlist[i][3])]
                        with open("../conjugative_systems/nucleotide_sequences/"+fname+".fa.DNA.fa", "a") as dnanew:
                            dnanew.write(operon+"\n")


###########################################

        else:
            orfstart=infolist[0][0]+"_"+infolist[0][1]
            orfstop=infolist[0][0]+"_"+str(int(infolist[len(infolist)-1][1])+1)
            nucstart=int(infolist[0][2])-1
            nucstop=int(infolist[len(infolist)-1][3])
            contigname=infolist[0][0]
            # print(orfstart,orfstop,nucstart,nucstop,contigname)
            with open("../conjugative_contigs/"+fname+".txt") as annofh:
                outputflag=False
                for line in annofh:
                    if orfstart+"\t" in line:
                        outputflag=True
                    if orfstop+"\t" in line:
                        outputflag=False
                    if outputflag:
                        with open("../conjugative_systems/annotations/"+fname+".txt", "a") as annonew:
                            annonew.write(line.split("\t")[0].rsplit("_",1)[0]+"_"+"1"+"_"+line.split("\t")[0].rsplit("_",1)[1]+"\t"+line.split("\t")[1]+"\n")
            with open("../conjugative_contigs/"+fname+".faa.orfs.fa") as aafh:
                outputflag=False
                for line in aafh:
                    if orfstart+" " in line:
                        outputflag=True
                    if orfstop+" " in line:
                        outputflag=False
                    if outputflag:
                        if ">" in line:
                            with open("../conjugative_systems/protein_sequences/"+fname+".faa.orfs.fa", "a") as aanew:
                                aanew.write(line.split(" ")[0].rsplit("_",1)[0]+"_"+"1"+"_"+line.split(" ")[0].rsplit("_",1)[1]+" "+line.split(" ",1)[1])
                        else:
                            with open("../conjugative_systems/protein_sequences/"+fname+".faa.orfs.fa", "a") as aanew:
                                aanew.write(line)
            with open("../conjugative_contigs/"+fname+".fa.DNA.fa") as dnafh:
                dnaheadfound=False
                dnastring=""
                for dna in dnafh:
                    if ">" in dna:
                        dnaheadfound=False
                    if ">"+contigname+"\n" in dna:
                        dnaheadfound=True
                        with open("../conjugative_systems/nucleotide_sequences/"+fname+".fa.DNA.fa", "a") as dnanew:
                            dnanew.write(dna.strip()+"_"+"1"+"\n")
                    elif dnaheadfound is True:
                        dnastring=dnastring+dna.strip()
                operon=dnastring[nucstart:nucstop]
                with open("../conjugative_systems/nucleotide_sequences/"+fname+".fa.DNA.fa", "a") as dnanew:
                    dnanew.write(operon)

    # print(infolist)
    # debugcounter=debugcounter+1
    # if debugcounter == 10:
    #     break

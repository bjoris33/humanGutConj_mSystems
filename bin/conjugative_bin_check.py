##############
# Author: Ben Joris
# Created: July 1st, 2020
# Purpose: output tsv of binning results for the conjugative contigs
##############

import glob
import pandas
import os

binDictList=[]
for i in glob.glob("*.fa"):
    accession=i.split(".")[0]
    conj_contigs="../assemblies/"+accession+"/conj_systems.fasta"
    temp_contigs=[]
    temp_matches=[]
    in_bin=[]
    with open(conj_contigs) as conjfh:
        for line in conjfh:
            if ">" in line:
                temp_contigs.append(line[1:].strip())
    for bin in glob.glob(accession+".fa.metabat-bins20/*"):
        with open(bin) as binfh:
            for line in binfh:
                if ">" in line:
                    if line[1:].strip() in temp_contigs:
                        temp_matches.append((line[1:].strip(),os.path.basename(bin).rsplit(".",1)[0]))
                        in_bin.append(line[1:].strip())
    for q in temp_matches:
        with open(accession+"_qa.txt") as qafh:
            for line in qafh:
                if line.split()[0].strip() == q[1]:
                    temp_dict={}
                    temp_dict["accession"]=accession
                    temp_dict["contig_name"]=q[0]
                    temp_dict["bin_id"]=q[1]
                    temp_dict["marker_lineage"]=line.split()[1]+" "+line.split()[2]
                    temp_dict["completion"]=line.split()[6]
                    temp_dict["redundancy"]=line.split()[7]
                    temp_dict["genome_size"]=line.split()[9]
                    temp_dict["number_of_scaffolds"]=line.split()[11]
                    binDictList.append(temp_dict)
    for v in temp_contigs:
        if v not in in_bin:
            temp_dict={}
            temp_dict["accession"]=accession
            temp_dict["contig_name"]=v
            temp_dict["bin_id"]="N/A"
            temp_dict["marker_lineage"]="N/A"
            temp_dict["completion"]=0.0
            temp_dict["redundancy"]=0.0
            temp_dict["genome_size"]=0
            temp_dict["number_of_scaffolds"]=0
            binDictList.append(temp_dict)

df=pandas.DataFrame(binDictList)
df.to_csv("../binning_information/conjugative_bins.tsv", sep="\t")

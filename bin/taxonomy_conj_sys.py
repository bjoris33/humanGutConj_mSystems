'''
Author: Ben Joris
Created: October 30th, 2019
    Edited: July 28th, 2020
Purpose: Extract the taxonomic information for all of the conjugative systems to create item data for import into anvio
'''
import glob

# populate dictionarys with taxonomic info with relation to file names
clss={}
phylum={}
with open("taxonomy_hgr.tab") as hgrfh:
    for line in hgrfh:
        if "Genome" in line:
            continue
        else:
            phylum[line.split("\t")[0]]=line.split("\t")[1]
            clss[line.split("\t")[0]]=line.split("\t")[2]
with open("taxonomy_umgs.tab") as umgsfh:
    for line in umgsfh:
        if "Genome" in line:
            continue
        else:
            phylum[line.split("\t")[0]]=line.split("\t")[2]
            clss[line.split("\t")[0]]=line.split("\t")[3]

# populate dictionary with info relating file names to fasta headers
fastaHeader={}
for file in glob.glob("../conjugative_systems/nucleotide_sequences/*"):
    with open(file) as fastafh:
        for line in fastafh:
            if ">" in line:
                fastaHeader[line[1:].strip()]=file.split(".")[0].rsplit("/",1)[1]

# populate dictionary with info relating anvio fasta headers to original fasta headers
anvioHeader={}
with open("../population_mapping/name_change.txt") as anviofh:
    for line in anviofh:
        anvioHeader[line.split("\t")[0]]=line.split("\t")[1].strip()

# get a list of the contigs used by anvio
# some from original list are filtered at import based on size
# file being read generated with `anvi-export-splits-and-coverages -p PROFILE.db -c /Volumes/data/gutDB/conjugative_operons/CONTIGS.db -o .`
headerlist=[]
with open("../population_mapping/MERGED/SAMPLES_MERGED-SPLITS.fa") as fafh:
    for line in fafh:
        if ">" in line:
            headerlist.append(line[1:].rsplit("_",2)[0].strip())
# output data to tab-sep text file for import into anvio
with open("pop_items_new.txt","a") as newfh:
    newfh.write("item_name"+"\t"+"phylum"+"\t"+"class"+"\n")
    for i in headerlist:
        with open("items_new.txt","a") as newfh:
            newfh.write(i+"_split_00001"+"\t"+phylum[fastaHeader[anvioHeader[i]]]+"\t"+clss[fastaHeader[anvioHeader[i]]]+"\n")

    print(i, phylum[fastaHeader[anvioHeader[i]]])

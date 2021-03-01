##############
# Author: Ben Joris
# Created: January 18th, 2021
# Purpose: Gather summary information about the incompatibility groupings, plasmid/genome status, taxonomy, length, source
##############

import glob
import pandas
from collections import defaultdict

# dictionary where all info will be kept
masterDict=defaultdict(dict)

### De Novo Assembled contigs ###

with open("../../remapping/mob_typer/combined.tsv") as fh:
    for line in fh:
        if "file_id" in line: # skipping the first line of file
            continue
        else:
            masterDict[line.split()[1].split(".")[0]]["Source"]="De Novo Assembled"
            masterDict[line.split()[1].split(".")[0]]["Length"]=line.split()[3]
            if line.split()[5] == "-":
                 masterDict[line.split()[1].split(".")[0]]["Incompatibility Group"]="N/A"
            else:
                masterDict[line.split()[1].split(".")[0]]["Incompatibility Group"]=line.split()[5]
            

with open("../../remapping/reassembly/de_novo_plasflow_predictions.tsv") as plasflow:
    for line in plasflow:
        if "contig_id" in line:
            continue
        elif "plasmid" in line.split()[5]:
            masterDict[line.split()[2]]["Predicted Plasmid/ICE"]="Plasmid"
        elif "chromosome" in line.split()[5]:
            masterDict[line.split()[2]]["Predicted Plasmid/ICE"]="ICE"
        else:
            masterDict[line.split()[2]]["Predicted Plasmid/ICE"]="N/A"
            
with open("../../remapping/reassembly_taxon/kaiju_phyclass.tsv") as taxfh:
    for line in taxfh:
        masterDict[line.split()[1]]["Phylum"]=line.split()[3][:-1]

### Genome Set Info ###

with open("../genome_set_tax.tsv") as taxfh:
    for line in taxfh:
        masterDict[line.split("\t")[0]]["Source"]="Genome Set"
        masterDict[line.split("\t")[0]]["Phylum"]=line.split("\t")[1].strip()
        
with open("../mob_typer/combined.tsv") as fh:
    for line in fh:
        if "file_id" in line: # skipping the first line of file
            continue
        else:
            masterDict[line.split()[1].rsplit(".",1)[0]]["Length"]=line.split()[3]
            if line.split()[5] == "-":
                 masterDict[line.split()[1].rsplit(".",1)[0]]["Incompatibility Group"]="N/A"
            else:
                masterDict[line.split()[1].rsplit(".",1)[0]]["Incompatibility Group"]=line.split()[5]

with open("../genome_set_conj/plasflow_predictions.tsv") as plasflow:
    for line in plasflow:
        if "contig_id" in line:
            continue
        elif "plasmid" in line.split()[5]:
            masterDict[line.split()[2]]["Predicted Plasmid/ICE"]="Plasmid"
        elif "chromosome" in line.split()[5]:
            masterDict[line.split()[2]]["Predicted Plasmid/ICE"]="ICE"
        else:
            masterDict[line.split()[2]]["Predicted Plasmid/ICE"]="N/A"
            
        
### Write final table ###

pandf=pandas.DataFrame(masterDict)
tpandf=pandf.transpose()
tpandf.to_csv("../systems_summary_table.tsv",sep="\t",na_rep=0,doublequote=False)
##############
# AUTHOR: Ben Joris
# CREATED: December 7th, 2020
    # Revised: July 8th, 2020
# PURPOSE: Create importable table for items, taxonomy and origin of assembly
##############

taxdict={}
with open("../reassembly_taxon/kaiju_phyclass.tsv") as fh:
    for line in fh:
        taxdict[line.split("\t")[1]]=line.split("\t")[3].strip()


with open("../reassembly_anvio/SAMPLES_MERGED/items_new.txt","a") as newfh:
    newfh.write("item_name"+"\t"+"phylum"+"\t"+"class"+"\t"+"origin_of_assembly"+"\n")
# need to run prior: anvi-export-splits-and-coverages -p ../reassembly_anvio/SAMPLES_MERGED/PROFILE.db -c ../reassembly_anvio/CONTIGS.db -o ../reassembly_anvio/SAMPLES_MERGED/
with open("../reassembly_anvio/SAMPLES_MERGED/SAMPLES_MERGED-SPLITS.fa") as fasta:
    for line in fasta:
        if ">" in line:
            with open("../reassembly_anvio/SAMPLES_MERGED/items_new.txt","a") as newfh:
                if "SRR5650" in line:
                    newfh.write(line.strip()[1:]+"\t"+taxdict[line.strip()[1:].rsplit("_",3)[0]].split()[0][:-1]+"\t"+taxdict[line.strip()[1:].rsplit("_",3)[0]].split()[1][:-1]+"\t"+"general"+"\n")
                if "SRR313" in line:
                    newfh.write(line.strip()[1:]+"\t"+taxdict[line.strip()[1:].rsplit("_",3)[0]].split()[0][:-1]+"\t"+taxdict[line.strip()[1:].rsplit("_",3)[0]].split()[1][:-1]+"\t"+"pre-term infant"+"\n")

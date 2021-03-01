##############
# AUTHOR: Ben Joris
# CREATED: January 7th, 2020
    # Revised: July 8th, 2020
# PURPOSE: Create layer data table for importing into anvio. Similar to get_country_data.py.
    # Created for novel assemblies in the original plasmid project.
##############

with open("../reassembly_anvio/SAMPLES_MERGED/layers_original.txt") as oldfh:
    for line in oldfh:
        if "layers" in line: # for the first line in the file, add the two new column names
            with open("../reassembly_anvio/SAMPLES_MERGED/layers_new.txt","a") as newfh:
                newfh.write(line.strip()+"\t"+"cohort"+"\n")
        elif "SORTED_PAIRED_SRR313" in line.split("\t")[0]:
            with open("../reassembly_anvio/SAMPLES_MERGED/layers_new.txt","a") as newfh:
                newfh.write(line.strip()+"\t"+"infant"+"\n")
        elif "SORTED_PAIRED_SRR565" in line.split("\t")[0]:
            with open("../reassembly_anvio/SAMPLES_MERGED/layers_new.txt","a") as newfh:
                newfh.write(line.strip()+"\t"+"general"+"\n")

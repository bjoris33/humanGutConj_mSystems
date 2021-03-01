##############
# Author: Ben Joris
# Created: August 25th, 2020
# Purpose: Separate contigs and write to Pyani input directory for conjugative systems extracted from genomes
    # Not part of main analyses
##############

import glob
curfh=""
for file in glob.glob("/Volumes/data/gutDB/paper_script_testing/plasmids/output/*.DNA.fa"):
    with open(file) as oldfh:
        for line in oldfh:
            if ">" in line:
                curfh=line[1:].strip()
                if "/" in curfh:
                    curfh=curfh.replace("/","_")
                if "," in curfh:
                    curfh=curfh.replace(",","_")
            with open("../ani_input/"+curfh+".fa","a") as newfh:
                newfh.write(line)

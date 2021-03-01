#!/bin/bash
##############
# Author: Ben Joris
# Created: July 27th, 2020
# Purpose: Run all scripts to create anvio profile of the mapping
##############

mkdir ../population_mapping/

cat ../conjugative_systems/nucleotide_sequences/* >> ../population_mapping/unformated_contigs.fa

anvi-script-reformat-fasta ../population_mapping/unformated_contigs.fa -o ../population_mapping/contigs.fa --simplify_names -r ../population_mapping/name_change.txt

bowtie2-build ../population_mapping/contigs.fa ../population_mapping/btdb

mkdir ../population_mapping/reads
mkdir ../population_mapping/mapping
mkdir ../population_mapping/profiles

anvi-gen-contigs-database -f ../population_mapping/contigs.fa -n "Conjugative System Ppopulation Mapping" -o ../population_mapping/CONTIGS.db -L 0

#### CHANGE INSTALL LOCATION OF DEDUPE BEFORE RUNNING #####
./pop_mapping_dl_map.sh

anvi-merge ../population_mapping/profiles/*/PROFILE.db -o ../population_mapping/MERGED -c ../population_mapping/CONTIGS.db

anvi-export-splits-and-coverages -p ../population_mapping/MERGED/PROFILE.db -c ../population_mapping/CONTIGS.db -o ../population_mapping/MERGED/

anvi-export-misc-data -p ../population_mapping/MERGED/PROFILE.db -t layers -o pop_originalmisc.txt

python get_country_data.py

anvi-import-misc-data pop_newmisc.txt -p ../population_mapping/MERGED/PROFILE.db -target-data-table layers --just-do-it

python taxonomy_conj_sys.py

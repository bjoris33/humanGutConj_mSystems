#!/bin/bash
##############
# Author: Ben Joris
# Created: July 6th, 2020
# Purpose: Create contig db, profile, and merge
##############

mkdir ../reassembly_anvio

anvi-gen-contigs-database -f ../reassembly_mapping/contigs.fa -L 0 -n "Reassembly Operons" -o ../reassembly_anvio/CONTIGS.db

for sample in $(ls ../reassembly_mapping/sorted_*.bam);do
  bn=`basename $sample .bam`
  anvi-profile -i $sample -c ../reassembly_anvio/CONTIGS.db -o ../reassembly_anvio/${bn} --num-threads 20
done

anvi-merge ../reassembly_anvio/sorted_*/PROFILE.db -o ../reassembly_anvio/SAMPLES_MERGED -c ../reassembly_anvio/CONTIGS.db

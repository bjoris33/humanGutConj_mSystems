#!/bin/bash
##############
# Author: Ben Joris
# Created: June 30th, 2020
# Purpose: Predict ORFs and annotated contigs that were predicted to be conjugative
##############

mkdir ../reassembly_prodigal_output

for i in $(ls ../reassembly_contigs/*.fa);do
        x=`basename $i .fa`
        prodigal -i $i -o "../reassembly_prodigal_output/${x}.genes" -a "../reassembly_prodigal_output/${x}.faa" -p meta
done

mkdir ../reassembly_diamond_output

for i in $(ls ../reassembly_prodigal_output/*.faa);do
  x=`basename $i .faa`
  diamond blastp -d /Volumes/data/uniref/uniref90.dmnd -p 20 -q $i -o ../reassembly_diamond_output/${x}.m8 --salltitles -k 10 --min-score 30 --outfmt 6
done

#!/bin/bash
##############
# Author: Ben Joris
# Created: September 9th, 2020
# Purpose: run samtools idxstats on all samples, run python script to form into tsv
##############


for file in $(ls ../reassembly_mapping/sorted_*.bam);do
  bn=`basename $file .bam`
  samtools idxstats $file > ../reassembly_mapping_data/${bn}.txt
done

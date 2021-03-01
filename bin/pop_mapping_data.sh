#!/bin/bash
##############
# Author: Ben Joris
# Created: September 11th, 2020
# Purpose: run samtools idxstats on all samples, run python script to form into tsv
##############


for file in $(ls ../*/sorted_*.bam);do
  bn=`basename $file .bam`
  samtools idxstats $file > ../pop_mapping_data/${bn}.txt
done

for file in $(ls ../asia_redo/*/sorted_*.bam);do
  bn=`basename $file .bam`
  samtools idxstats $file > ../pop_mapping_data/${bn}.txt
done

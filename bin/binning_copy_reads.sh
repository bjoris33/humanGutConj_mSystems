#!/bin/bash
##############
# Author: Ben Joris
# Created: July 31st, 2020
# Purpose: To simplify scripts, reads will be copied to separate directories
##############

while read line; do
  arrIN=(${line// / })
  sample=${arrIN[0]}
  spades.py -1 ../population_mapping/reads/paired_${sample}_1.fastq.gz ../population_mapping/reads/paired_${sample}_2.fastq.gz --meta -o ../assemblies/${sample}/ -t $threads
  if [[ ${sample} == *"SRR565"* ]]; then
    cp ../population_mapping/reads/paired_${sample}_1.fastq.gz ../binning/general/reads/
    cp ../population_mapping/reads/paired_${sample}_2.fastq.gz ../binning/general/reads/
  fi
  if [[ ${sample} == *"SRR313"* ]]; then
    cp ../population_mapping/reads/paired_${sample}_1.fastq.gz ../binning/infant/reads/
    cp ../population_mapping/reads/paired_${sample}_2.fastq.gz ../binning/infant/reads/
  fi
done <reassembly_samples.txt

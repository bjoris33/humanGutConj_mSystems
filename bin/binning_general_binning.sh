#!/bin/bash
##############
# Author: Ben Joris
# Created: July 31st, 2020
# Purpose: Bin general assemblies
##############

threads=20

for i in $(ls ../binning/general/reads/paired_*_1.fastq.gz);do
  bn=`basename $fastq _1.fastq.gz`
  IFS="_" read -r -a array <<< $bn
  sample=${array[1]}
  allbam=`ls ../binning/general/mapping/${sample}/sorted_*.bam`
  runMetaBat.sh --numThreads $threads ../assemblies/${sample}/reformated.fasta $allbam
done

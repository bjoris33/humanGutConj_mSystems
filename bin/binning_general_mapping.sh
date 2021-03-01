#!/bin/bash
##############
# Author: Ben Joris
# Created: July 31st, 2020
# Purpose: Map short read data to all assemblies to allow for binning of data
##############

mkdir ../binning/general/mapping/

threads=20

for i in $(ls ../binning/general/reads/paired_*_1.fastq.gz); do
  bn1=`basename $fastq _1.fastq.gz`
  IFS="_" read -r -a array <<< $bn1
  outersample=${array[1]}
  mkdir ../binning/general/mapping/${outersample}
  bowtie2-build ../assemblies/${outersample}/reformated.fasta ../binning/general/mapping/${outersample}/bowtiedb
  for fastq in $(ls ../binning/general/reads/paired_*_1.fastq.gz);do
    bn2=`basename $fastq _1.fastq.gz`
    IFS="/" read -r -a array2 <<< $bn2
    innersample=${array2[1]}
    bowtie2 -p $threads -1 $fastq -2 ../binning/general/reads/paired_${innersample}_2.fastq.gz -x ../binning/general/mapping/${outersample}/bowtiedb --no-unal --no-mixed --no-discordant -S ../binning/general/mapping/${outersample}/${innersample}.sam
    samtools view --threads $threads -bS ../binning/general/mapping/${outersample}/${innersample}.sam > ../binning/general/mapping/${outersample}/${innersample}.bam
    rm ../binning/general/mapping/${outersample}/${innersample}.sam
    anvi-init-bam ../binning/general/mapping/${outersample}/${innersample}.bam -o ../binning/general/mapping/${outersample}/sorted_${innersample}.bam
    rm ../binning/general/mapping/${outersample}/${innersample}.bam
  done
done

#!/bin/bash
##############
# Author: Ben Joris
# Created: July 31st, 2020
# Purpose: Map short read data to all assemblies to allow for binning of data
##############

mkdir ../binning/infant/mapping/

threads=20

for i in $(ls ../binning/infant/reads/paired_*_1.fastq.gz); do
  bn1=`basename $fastq _1.fastq.gz`
  IFS="_" read -r -a array <<< $bn1
  outersample=${array[1]}
  mkdir ../binning/infant/mapping/${outersample}
  bowtie2-build ../assemblies/${outersample}/reformated.fasta ../binning/infant/mapping/${outersample}/bowtiedb
  for fastq in $(ls ../binning/infant/reads/paired_*_1.fastq.gz);do
    bn2=`basename $fastq _1.fastq.gz`
    IFS="/" read -r -a array2 <<< $bn2
    innersample=${array2[1]}
    bowtie2 -p $threads -1 $fastq -2 ../binning/infant/reads/paired_${innersample}_2.fastq.gz -x ../binning/infant/mapping/${outersample}/bowtiedb --no-unal --no-mixed --no-discordant -S ../binning/infant/mapping/${outersample}/${innersample}.sam
    samtools view --threads $threads -bS ../binning/infant/mapping/${outersample}/${innersample}.sam > ../binning/infant/mapping/${outersample}/${innersample}.bam
    rm ../binning/infant/mapping/${outersample}/${innersample}.sam
    anvi-init-bam ../binning/infant/mapping/${outersample}/${innersample}.bam -o ../binning/infant/mapping/${outersample}/sorted_${innersample}.bam
    rm ../binning/infant/mapping/${outersample}/${innersample}.bam
  done
done

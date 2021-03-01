#!/bin/bash
##############
# Author: Ben Joris
# Created: July 28th, 2020
# Purpose: Download and process reads for population mapping
  # Map reads to bowtie2 database, reformat mapping files, generate anvi profile
##############

##### CHANGE INSTALL LOCATION BEFORE RUNNING #####
dedupe=/Volumes/data/bin/bbmap/dedupe.sh

## CHANGE to within limits of your system ##
threads=20

while read line; do
  arrIN=(${line// / })
  sample=${arrIN[0]}
  fasterq-dump $sample -e $threads -O ../population_mapping/reads -p
  cache-mgr -c
  $dedupe in=../population_mapping/reads/${sample}_1.fastq out=../population_mapping/reads/${sample}_dd_1.fastq ac=f -Xmx100g
  $dedupe in=../population_mapping/reads/${sample}_2.fastq out=../population_mapping/reads/${sample}_dd_2.fastq ac=f -Xmx100g
  perl merge_filtered_fastq.pl ../population_mapping/reads/${sample}_dd_1.fastq ../population_mapping/reads/${sample}_dd_2.fastq ../population_mapping/reads/${sample}_merged_1.fastq ../population_mapping/reads/${sample}_merged_2.fastq
  trimmomatic PE -threads 8 -phred33 ../population_mapping/reads/${sample}_merged_1.fastq ../population_mapping/reads/${sample}_merged_2.fastq ../population_mapping/reads/paired_${sample}_1.fastq ../population_mapping/reads/${sample}_unpaired_1.fastq ../population_mapping/reads/paired_${sample}_2.fastq ../population_mapping/reads/${sample}_unpaired_2.fastq LEADING:10 TRAILING:10
  rm ../population_mapping/reads/${sample}_1.fastq
  rm ../population_mapping/reads/${sample}_2.fastq
  rm ../population_mapping/reads/${sample}_dd_1.fastq
  rm ../population_mapping/reads/${sample}_dd_2.fastq
  rm ../population_mapping/reads/${sample}_merged_1.fastq
  rm ../population_mapping/reads/${sample}_merged_2.fastq
  rm ../population_mapping/reads/${sample}_unpaired_1.fastq
  rm ../population_mapping/reads/${sample}_unpaired_2.fastq
  gzip ../population_mapping/reads/paired_${sample}_1.fastq
  gzip ../population_mapping/reads/paired_${sample}_2.fastq
  bowtie2 -p $threads -x ../population_mapping/btdb -1 ../population_mapping/reads/paired_${sample}_1.fastq.gz -2 ../population_mapping/reads/paired_${sample}_2.fastq.gz --no-unal --no-mixed --no-discordant -S ../population_mapping/mapping/${sample}.sam
  samtools view --threads $threads -bS ../population_mapping/mapping/${sample}.sam > ../population_mapping/mapping/${sample}.bam
  anvi-init-bam ../population_mapping/mapping/${sample}.bam -o ../population_mapping/mapping/sorted_${sample}.bam
  anvi-profile -i ../population_mapping/mapping/sorted_${sample}.bam -c ../population_mapping/CONTIGS.db -o ../population_mapping/profiles/${sample} --num-threads $threads
done <pop_mapping_samples.txt

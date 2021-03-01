#!/bin/bash
##############
# Author: Ben Joris
# Created: July 2nd, 2020
# Purpose: Combines operon fasta files,
  # builds bowtie index,
  # maps already downloaded and processed reads
##############

threads=20

mkdir ../reassembly_mapping

# ensuring that the fasta files end in newline before concatenating
sed -i '$a\' ../reassembly_operons/*.fa

cat ../reassembly_operons/*.fa >> ../reassembly_mapping/contigs.fa

bowtie2-build ../reassembly_mapping/contigs.fa ../reassembly_mapping/mapping_db

while read line; do
  arrIN=(${line// / })
  sample=${arrIN[0]}
  echo $sample &>> mapping.out
  bowtie2 -p 20 -x ../reassembly_mapping/mapping_db -1 ../population_mapping/reads/paired_${sample}_1.fastq.gz ../population_mapping/reads/paired_${sample}_2.fastq.gz --no-unal --no-mixed --no-discordant -S ../reassembly_mapping/${sample}.sam &>> mapping.out
done <reassembly_samples.txt


for i in $(ls ../reassembly_mapping/*.sam);do
  bn=`basename $i .sam`
  echo $bn
  samtools view -bS $i > ../reassembly_mapping/${bn}.bam
  rm $i
done

for sample in $(ls ../reassembly_mapping/*.bam);do
  bn=`basename $sample .bam`
  anvi-init-bam $sample -o ../reassembly_mapping/sorted_${bn}.bam;
done

#!/bin/bash
##############
# Author: Ben Joris
# Created: May 22nd, 2020
# Purpose: For adult dataset, map to already created bowtie databases, bin with metabat2
##############

for samplepath in $(ls ../adult_na/data/mapping/SRR*/bowtiedb.1.bt2);do
  IFS='/' read -ra samplearray <<< $samplepath
  echo ${samplearray[4]}
  for innersamplepath in $(ls ../adult_na/data/mapping/SRR*/bowtiedb.1.bt2);do
    IFS='/' read -ra innersamplearray <<< $innersamplepath
    echo ${innersamplearray[4]}
    /Volumes/data/bin/bowtie2.3.5/bowtie2 -p 20 -1 ../adult_na/data/reads/processed/paired_${innersamplearray[4]}_1.fastq.gz -2 ../adult_na/data/reads/processed/paired_${innersamplearray[4]}_2.fastq.gz -x ../adult_na/data/mapping/${samplearray[4]}/bowtiedb --no-unal --no-mixed --no-discordant -S ../adult_na/data/mapping/${samplearray[4]}/${innersamplearray[4]}.sam
    samtools view --threads 20 -bS ../adult_na/data/mapping/${samplearray[4]}/${innersamplearray[4]}.sam > ../adult_na/data/mapping/${samplearray[4]}/${innersamplearray[4]}.bam
    anvi-init-bam ../adult_na/data/mapping/${samplearray[4]}/${innersamplearray[4]}.bam -o ../adult_na/data/mapping/${samplearray[4]}/sorted_${innersamplearray[4]}.bam
  done
  allbam=`ls ../adult_na/data/mapping/${samplearray[4]}/sorted_*.bam`
  cp ../adult_na/data/assemblies/${samplearray[4]}/contigs.fa ${samplearray[4]}.fa
  /Volumes/data/bin/miniconda3/pkgs/metabat2-2.12.1-0/bin/runMetaBat.sh --numThreads 20 ${samplearray[4]}.fa $allbam
  rm ../adult_na/data/mapping/${samplearray[4]}/*.sam
  rm ../adult_na/data/mapping/${samplearray[4]}/*.bam
  rm ../adult_na/data/mapping/${samplearray[4]}/sorted_*.bam.bai
  echo "****"
done

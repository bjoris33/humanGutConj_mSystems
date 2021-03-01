#!/bin/bash
##############
# Author: Ben Joris
# Created: May 22nd, 2020
# Purpose: For adult dataset, map to already created bowtie databases, bin with metabat2
##############

for samplepath in $(ls ../infant/data/mapping/SRR*/bowtiedb.1.bt2);do
  IFS='/' read -ra samplearray <<< $samplepath
  echo ${samplearray[4]}
  for innersamplepath in $(ls ../infant/data/mapping/SRR*/bowtiedb.1.bt2);do
    IFS='/' read -ra innersamplearray <<< $innersamplepath
    echo ${innersamplearray[4]}
    /Volumes/data/bin/bowtie2.3.5/bowtie2 -p 20 -1 ../infant/data/reads/processed/paired_${innersamplearray[4]}_1.fastq.gz -2 ../infant/data/reads/processed/paired_${innersamplearray[4]}_2.fastq.gz -x ../infant/data/mapping/${samplearray[4]}/bowtiedb --no-unal --no-mixed --no-discordant -S ../infant/data/mapping/${samplearray[4]}/${innersamplearray[4]}.sam
    samtools view --threads 20 -bS ../infant/data/mapping/${samplearray[4]}/${innersamplearray[4]}.sam > ../infant/data/mapping/${samplearray[4]}/${innersamplearray[4]}.bam
    anvi-init-bam ../infant/data/mapping/${samplearray[4]}/${innersamplearray[4]}.bam -o ../infant/data/mapping/${samplearray[4]}/sorted_${innersamplearray[4]}.bam
  done
  allbam=`ls ../infant/data/mapping/${samplearray[4]}/sorted_*.bam`
  cp ../infant/data/assemblies/${samplearray[4]}/contigs.fa ${samplearray[4]}.fa
  /Volumes/data/bin/miniconda3/pkgs/metabat2-2.12.1-0/bin/runMetaBat.sh --numThreads 20 ${samplearray[4]}.fa $allbam
  rm ../infant/data/mapping/${samplearray[4]}/*.sam
  rm ../infant/data/mapping/${samplearray[4]}/*.bam
  rm ../infant/data/mapping/${samplearray[4]}/sorted_*.bam.bai
  echo "****"
done

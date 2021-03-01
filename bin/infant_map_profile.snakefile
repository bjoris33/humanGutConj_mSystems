##############
# Author: Ben Joris
# Created: May 19th, 2020
# Purpose: Map short reads to assemblies to allow for metabat2 usage
##############
import glob

sample_list=[]
for i in glob.glob("/Volumes/data/gutDB/conjugative_operons/infant_assemblies/north_american/paired_SRR313*/scaffolds.fasta"):
    sample_list.append(i.rsplit("/",2)[1].split("_")[1])

rule all:
    input:
        expand("../infant/data/mapping/{sample}/bowtiedb.1.bt2", sample=sample_list)

rule bt_db:
    input:
        "../infant/data/assemblies/{sample}/contigs.fa"
    output:
        "../infant/data/mapping/{sample}/bowtiedb.1.bt2"
    params:
        prefix="../infant/data/mapping/{sample}/bowtiedb"
    threads: 1
    shell:
        "/Volumes/data/bin/bowtie2.3.5/bowtie2-build {input} {params.prefix}"

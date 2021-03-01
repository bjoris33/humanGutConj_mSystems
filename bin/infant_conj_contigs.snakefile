##############
# Author: Ben Joris
# Created: June 19th, 2020
# Purpose: From contig.db, extract conjugative systems, for preterm infants
##############
import glob

sample_list=[]
for i in glob.glob("/Volumes/data/gutDB/conjugative_operons/infant_assemblies/north_american/paired_SRR313*/scaffolds.fasta"):
    sample_list.append(i.rsplit("/",2)[1].split("_")[1])


rule all:
    input:
        expand("../infant/data/assemblies/{sample}/conj_contigs.fa", sample=sample_list)


rule t4ss:
    input:
        "../infant/data/assemblies/{sample}/contigs.db"
    output:
        "../infant/data/assemblies/{sample}/t4ss.fa"
    threads: 1
    shell:
        "anvi-get-sequences-for-hmm-hits -c {input} --hmm-sources T4SS -o {output}"

rule t4cp:
    input:
        "../infant/data/assemblies/{sample}/contigs.db"
    output:
        "../infant/data/assemblies/{sample}/t4cp.fa"
    threads: 1
    shell:
        "anvi-get-sequences-for-hmm-hits -c {input} --hmm-sources T4CP -o {output}"

rule relaxase:
    input:
        "../infant/data/assemblies/{sample}/contigs.db"
    output:
        "../infant/data/assemblies/{sample}/relaxase.fa"
    threads: 1
    shell:
        "anvi-get-sequences-for-hmm-hits -c {input} --hmm-sources Relaxase -o {output}"

rule get_conj_systems:
    input:
        "../infant/data/assemblies/{sample}/relaxase.fa",
        "../infant/data/assemblies/{sample}/t4cp.fa",
        "../infant/data/assemblies/{sample}/t4ss.fa",
        "../infant/data/assemblies/{sample}/contigs.fa"
    output:
        "../infant/data/assemblies/{sample}/conj_contigs.fa"
    threads: 1
    script:
        "get_conj_systems.py"

##############
# Author: Ben Joris
# Created: May 21st, 2020
# Purpose: From contig.db, extract conjugative systems
##############
import glob

sample_list=[]
for i in glob.glob("/Volumes/data/gutDB/conjugative_operons/infant_assemblies/adult_na/assembly_SRR*/scaffolds.fasta"):
    sample_list.append(i.rsplit("/",2)[1].split("_")[1])


rule all:
    input:
        expand("../adult_na/data/assemblies/{sample}/conj_contigs.fa", sample=sample_list)


rule t4ss:
    input:
        "../adult_na/data/assemblies/{sample}/contigs.db"
    output:
        "../adult_na/data/assemblies/{sample}/t4ss.fa"
    threads: 1
    shell:
        "anvi-get-sequences-for-hmm-hits -c {input} --hmm-sources T4SS -o {output}"

rule t4cp:
    input:
        "../adult_na/data/assemblies/{sample}/contigs.db"
    output:
        "../adult_na/data/assemblies/{sample}/t4cp.fa"
    threads: 1
    shell:
        "anvi-get-sequences-for-hmm-hits -c {input} --hmm-sources T4CP -o {output}"

rule relaxase:
    input:
        "../adult_na/data/assemblies/{sample}/contigs.db"
    output:
        "../adult_na/data/assemblies/{sample}/relaxase.fa"
    threads: 1
    shell:
        "anvi-get-sequences-for-hmm-hits -c {input} --hmm-sources Relaxase -o {output}"

rule get_conj_systems:
    input:
        "../adult_na/data/assemblies/{sample}/relaxase.fa",
        "../adult_na/data/assemblies/{sample}/t4cp.fa",
        "../adult_na/data/assemblies/{sample}/t4ss.fa",
        "../adult_na/data/assemblies/{sample}/contigs.fa"
    output:
        "../adult_na/data/assemblies/{sample}/conj_contigs.fa"
    threads: 1
    script:
        "get_conj_systems.py"

##############
# Author: Ben Joris
# Created: May 19th, 2020
# Purpose: Map short reads to assemblies to allow for metabat2 usage
##############
import glob

sample_list=[]
for i in glob.glob("/Volumes/data/gutDB/conjugative_operons/infant_assemblies/adult_na/assembly_SRR*/scaffolds.fasta"):
    sample_list.append(i.rsplit("/",2)[1].split("_")[1])

rule all:
    input:
        expand("../adult_na/data/mapping/{sample}/sorted_{inner_sample}.bam", sample=sample_list, inner_sample=sample_list)

rule bt_db:
    input:
        "../adult_na/data/assemblies/{sample}/contigs.fa"
    output:
        "../adult_na/data/mapping/{sample}/bowtiedb.1.bt2"
    params:
        prefix="../adult_na/data/mapping/{sample}/bowtiedb"
    threads: 1
    shell:
        "/Volumes/data/bin/bowtie2.3.5/bowtie2-build {input} {params.prefix}"

rule bt_map:
    input:
        "../adult_na/data/reads/processed/paired_{inner_sample}_1.fastq.gz",
        "../adult_na/data/reads/processed/paired_{inner_sample}_2.fastq.gz",
        "../adult_na/data/mapping/{sample}/bowtiedb.1.bt2"
    output:
        temp("../adult_na/data/mapping/{sample}/{inner_sample}.sam")
    params:
        prefix="../adult_na/data/mapping/{sample}/bowtiedb"
    threads: 20
    log:
        "../logs/mapping/{sample}_{inner_sample}.log"
    shell:
        "/Volumes/data/bin/bowtie2.3.5/bowtie2 -p {threads} -1 {input[0]} -2 {input[1]} -x {params.prefix} --no-unal --no-mixed --no-discordant -S {output} 2> {log}"

rule sam_bam:
    input:
        temp("../adult_na/data/mapping/{sample}/{inner_sample}.sam")
    output:
        temp("../adult_na/data/mapping/{sample}/{inner_sample}.bam")
    threads: 1
    shell:
        "samtools view -bS {input} > {output}"

rule init_bam:
    input:
        temp("../adult_na/data/mapping/{sample}/{inner_sample}.bam")
    output:
        "../adult_na/data/mapping/{sample}/sorted_{inner_sample}.bam"
    threads: 1
    shell:
        "anvi-init-bam {input} -o {output}"

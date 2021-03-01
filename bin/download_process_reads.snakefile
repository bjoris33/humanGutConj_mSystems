##############
# AUTHOR: Ben Joris
# CREATED: May 19th, 2020
# PURPOSE: Download, process reads.
##############
# INPUT: .txt list of SRA accessions to download, add to config file for file location
# CONFIG: Installation locations of dependencies
# DEPENDENCIES:
##############
import glob
# Name of the config file
configfile: "CONFIG_dl.yaml"

# Populate list with the accession from names of directories used for previous steps in pipeline
sample_list=[]
for i in glob.glob("/Volumes/data/gutDB/conjugative_operons/infant_assemblies/adult_na/assembly_SRR*/scaffolds.fasta"):
    sample_list.append(i.rsplit("/",2)[1].split("_")[1])

# Define the end result of this snakefile
rule all:
    input:
        expand("../adult_na/data/reads/processed/paired_{sample}_{num}.fastq", sample=sample_list, num=[1,2])

# Download the files from the SRA using fasterq-dump
# clear cache following download of sample
rule sra_download:
    output:
        temp("../adult_na/data/reads/raw/{sample}_1.fastq"),
        temp("../adult_na/data/reads/raw/{sample}_2.fastq")
    params:
        fasterq=config["fasterq"],
        cache=config["cache"],
        samplename="{sample}",
        outdir="../adult_na/data/reads/raw/"
    threads: 20
    log: "../log/downloads/{sample}_dl.log"
    benchmark:
        "../benchmarks/fasterq-dump/{sample}.tsv"
    shell:
        """
        {params.fasterq} {params.samplename} -e {threads} -O {params.outdir} -p 2> {log}
        {params.cache} -c ~bjoris/ncbi/sra
        """
# trim the reads
rule trimmomatic:
    input:
        fwd="../adult_na/data/reads/raw/{sample}_1.fastq",
        rev="../adult_na/data/reads/raw/{sample}_2.fastq"
    output:
        fwd_pair="../adult_na/data/reads/processed/paired_{sample}_1.fastq",
        fwd_unpair="../adult_na/data/reads/processed/unpaired_{sample}_1.fastq",
        rev_pair="../adult_na/data/reads/processed/paired_{sample}_2.fastq",
        rev_unpair="../adult_na/data/reads/processed/unpaired_{sample}_2.fastq"
    threads: 20
    params:
        trimmomatic=config["trimmomatic"]
    shell:
        "java -jar {params.trimmomatic} PE -threads {threads} -phred33  {input.fwd} {input.rev} {output.fwd_pair} {output.fwd_unpair} {output.rev_pair} {output.rev_unpair} LEADING:20 TRAILING:20"

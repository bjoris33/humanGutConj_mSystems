##############
# Author: Ben Joris
# Created: May 19th, 2020
# Purpose: Generate contigs.db and run hmm profiles for infant assemblies
##############
import glob

sample_list=[]
for i in glob.glob("/Volumes/data/gutDB/conjugative_operons/infant_assemblies/north_american/paired_SRR*/scaffolds.fasta"):
    sample_list.append(i.rsplit("/",2)[1].split("_")[1])

rule all:
    input:
        expand("../infant/data/assemblies/{sample}/contigs.db", sample=sample_list)

rule rename:
    input:
        "/Volumes/data/gutDB/conjugative_operons/infant_assemblies/north_american/paired_{sample}/scaffolds.fasta"
    output:
        "../infant/data/assemblies/{sample}/contigs.fa"
    threads: 1
    shell:
        "anvi-script-reformat-fasta {input} --simplify-names -o {output}"

rule gen_db:
    input:
        "../infant/data/assemblies/{sample}/contigs.fa"
    output:
        "../infant/data/assemblies/{sample}/contigs.db"
    params:
        projectname="{sample}"
    threads: 1
    shell:
        """
        anvi-gen-contigs-database -f {input} -n {params.projectname} -o {output}
        anvi-run-hmms -c {output} -T {threads}
        """

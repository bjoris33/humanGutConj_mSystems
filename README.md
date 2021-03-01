# Supplementary Methods and Materials for the mSystems "Separation of cohorts on the basis of bacterial type IV conjugation systems identified from metagenomic assemblies paper

## Table of contents

This Readme will have the workflow below the TOC

### Bin
* All scripts used within the project

### Figures
* PDFs of the figures generated and scripts for generating the figures


In this Readme, you will find the workflow necessary for recapitulating the workflow I used to generate the results in the paper. Unfortunately, these methods span back well over a year, and involve a number of disjointed processes, so there is no master script for running the methodology. Additionally, the processes to months to run, so it's probably for the best not to lock your workstation into running this scripts for eternity.

System information:

I ran these processes on a Linux server with aIntel(R) Xeon(R) CPU E5-2670 v3 @ 2.30GHz processor and 256GB of RAM.

Run in a conda environment with the following programs installed:
- bowtie2
- anvi'o
- metaSPAdes
- bowtie2
- SRA toolkit
- Trimmomatic
- Prodigal
- Diamond
- metabat2
- checkm
- Mash
- PlasFlow
- MOB suite

Follow instructions in HMM-information.txt for instructions on how to add HMM profiles for conjugative systems.

Installed outside conda environment:
- dedupe (used in scripts for downloading and processing reads, change install location in scripts)
- kaiju (need to edit location of kaiju install and nodes files)

## Step-by-Step Workflow (run from bin folder)

### Section 1: Download and annotate the gut genome database

**STEP 1:**
`./genome_download.sh`

* downloads the genomes from EBI FTP site via wget
* genomes from: https://doi.org/10.1038/s41586-019-0965-1
* reformats the fasta headers to replace tab whitespace with underscores
* downloads taxonomy table to extend information in fasta headers
* extends fasta headers with taxonomy info and saves to `../genomes` folder

**STEP 2:**
`./genome_annotation.sh`

**NOTE:** Prodigal and Diamond must be in PATH to run script as is, otherwise, call install location on your workstation
* the script first predicts the open reading frames using Prodigal
* the UniRef90 database must be downloaded and placed in `../uniref` (relative to bin)
* script replaces white space with a colon to avoid truncation with Diamond
* Diamond db is made using the UniRef90 database
* Open reading frames are aligned against UniRef90 database with BLASTP module of Diamond
* max 10 matches with a bitscore higher than 30 will be output to `../diamond_output`

### Section 2: Identify Conjugative Systems using annotations

`./conj_db_master.sh`
* I apologize in advance for the naming conventions
* will run a suite of `.sh`/`.py` scripts
* identifies potential conjugative systems based on word search strategies for relaxases and T4SS/T4CP annotations, outputs of .faa.contigs (.m8 annotations), .faa.orfs.fa (protein sequences), .fa.DNA.fa (DNA sequences) in `../conjugative_contigs/`
* finds the most frequent/best annotations for each ORF and outputs to `../conjugative_contigs/*.txt`
* gets the lengths of conjugative contigs, output in `../summary_data/contiglengths` and `../summary_data/`
* gets frequencies of all gene annotations across all the genomes, output in `../summary_data/geneFreq.txt`
* gets frequencies of conjugative protein annotations on identified contigs, output in `../summary_data/conjCount.txt` and `../summary_data/conjCountsAndLengths.txt`
* outputs .tsv files of the annotations for each identified contig, highlighting conjugative proteins, output in `../annotation_tables/`
* extracts regions containing conjugative systems from the contigs. This is explicitly to avoid potential issues of measuring average mapping frequencies of contigs containing integrative and conjugative elements (ICEs). Output to `../conjugative_systems`

# Section 3: Population mapping to identified conjugative systems

**`pop_mapping_dl.sh` needs to be edited beforehand**
`./pop_mapping_master.sh`
* combines all extracted DNA sequences containing conjugative systems into `../population_mapping/unformated_contigs.fa`
* reformats fasta file to be compliant with downstream programs and retains a record of the format change, `../population_mapping/contigs.fa`, `../population_mapping/name_change.txt`
* bowtie2 database is built from `../population_mapping/contigs.fa` and output in `../population_mapping/`
* anvi'o contigs database is created in `../population_mapping/`
* reads are downloaded based on information in `pop_mapping_samples.txt`, processed, and output in `../population_mapping/reads/`
* processed reads are mapped to bowtie2 database, SAM files are converted to BAM files and sorted/indexed
* anvi'o profiles are generated for each sample, output in `../population_mapping/profiles/`
* anvi'o profiles merged and output in `../population_mapping/MERGED`
* adds country data and taxonomic data to the anvi'o profile

**At this point, an equivalent to the population mapping anvi'o circular phylogram is viewable**

# Section 4: Reassembly of select samples and mapping to conjugative systems

`./reassembly_map_master.sh`
* assembles metagenomes, and predicts conjugative systems, output in `../assemblies/`
* combines all predicted conjugative systems into one file, `../reassembly/contigs.fa`
* separates all contigs into separate fasta files, output in `../reassembly_contigs/`
* ORF prediction and annotation, output in `../reassembly_prodigal_output/` and `../reassembly_diamond_output/`
* annotation tables with a focus on conjugative protein output to `../reassembly_orf_tables/`
* conjugative regions of contigs are extracted and output to `../reassembly_operons/`
* short read data are mapped to conjugative systems and sorted bam files are output to `../reassembly_mapping/`
* anvi'o profiles are generated, merged profile is output in `../reassembly_anvio/SAMPLES_MERGED/`
* Kaiju is run to predict taxonomy of the contigs (script must be edited with install location of kaiju and databases)
* Cohort and taxonomy data are imported into anvi'o profile

**At this point, an equivalent to the reassembly anvi'o circular phylogram is viewable**

# Section 5: Binning of reassemblies

`./binning_master.sh`
* reads are copied to `../binning/general/reads/` and `../binning/infant/reads/`
* reads are mapped to assemblies from same cohort, sam files are converted to bam files and sorted, output to `../binning/general/mapping/` and `../binning/infant/mapping/`
* binning with metabat2, output in working directory (the bin folder)
* CheckM run to assess bin quality, output in working directory
* evaluate proportions of conjugative systems included in metagenomic bins, output in `../binning_information/`

# Section 6: PlasFlow and MOB suite
* `PlasFlow.py --input contigs.fa --output plasflow_predictions.tsv` ran on set of full contigs (not extracted operons) for the "reassemblies" and genome set contigs
* before `mob_typer` can be used, each contig must be separated, `separate_contigs.py` was used, full contigs file must be saved as `../genome_set_conj/contigs.fa`
* `run_mob_typer.sh` to run MOB suite, `combine_mob_typer.sh` to combine into one table

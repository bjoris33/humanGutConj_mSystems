#!/bin/bash

# Written and commented by Ben Joris

# This script will download the genomes into your working directory
# also will unzip the files
# reformat fasta headers to remove spaces (spaces are problematic for a number of programs that handle fasta files)

# download the files from the FTP site
wget ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/umgs_analyses/hgr/genomes/*
wget ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/umgs_analyses/umgs/genomes/*

# unzip the files
gunzip *.fa.gz

# at this point you will have all 2505 genomes downloaded and unzipped
# unfortunately the fasta headers are uninformative in their current form
# some have no identifier of file and/or taxa, and others have spaces
# different problems for three groups of genomes

# taxonomy tables are going to be used to fix the fasta headers
wget ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/umgs_analyses/taxonomy_hgr.tab
wget ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/umgs_analyses/taxonomy_umgs.tab

# replace spaces with underscores beforehand to optimize them for insertion into fasta headers
tr '\t' '_' <taxonomy_hgr.tab>hgr.tab
tr '\t' '_' <taxonomy_umgs.tab>umgs.tab

# make a new directory for where the genomes will be saved after editing
mkdir ../genomes


# edit the fasta headers based on their groups and save them to the genomes directory
# for loop to go through all the newly downloaded fasta files
for i in $(ls *.fa);do
  bn=`basename $i .fa` # extract the basename for searching purposes
  newfile="../genomes/"$i # define new file name/location
  if [[ $bn == *"UMGS"* ]]; then # check if file name has UMGS in it
    newfh=`grep ${bn}_ umgs.tab` # use grep to acquire info for new fasta header
    sed  "s/>/>$newfh\_/" $i > $newfile # sed will insert the information acquired by grep at the start of the fasta header
  elif [[ $bn == *"GCF"* ]]; then # Check if a GCF genome
    tr ' ' '_' <$i>$newfile #replace all spaces with underscores for program compatibility
  else # this will alter all other genomes which are a "third" group
    newfh=`grep ${bn}_ hgr.tab` # same idea as above but with the other taxonomy file
    sed  "s/>/>$newfh\_/" $i > $newfile # same as above
  fi
done

rm *.fa # remove the unformatted genomes to save space

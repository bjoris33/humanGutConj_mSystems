#!/bin/bash

# Written and commented by Ben Joris

# The first step in annotating the genomes is predicting the open reading frames
# Prodidal was used as it is desined for bacterial open reading frame prediction

mkdir ../prodigal_output # make a directory for the output of prodigal to be saved to

# Prodigal is required to be installed on your system for this next step
# /Volumes/data/bin/Prodigal/prodigal was the install location of the executable Prodigal on our server
# loop through all the genomes, predicted their ORFs, and save the output to the new folder
for i in $(ls ../genomes/*.fa);do
        x=`basename $i .fa`
        prodigal -i $i -o "../prodigal_output/${x}.genes" -a "prodigal_output/${x}.faa"
done
# predicted ORF protein sequences are saved in the .faa files

# For this next step, you have to have the Diamond mapping program installed
# Also need to have UniRef90 protein database downloaded and converted into Diamond database
# To turn UniRef90 into Diamond database run (in my case, saved in the folder where I downloaded UniRef90):
tr ' ' ':' <../uniref/uniref90.fasta>../uniref/uniref90.faa # I did this to avoid compatibility issues down the line, spaces==bad

# Creates the diamond database
# I saved it in a separate directory than my project for future usage, you can change to `-d uniref90` if you want it in your project folder
diamond makedb --in ../uniref/uniref90.faa -d ../uniref/uniref90

# Map predicted protein sequences to the UniRef90 database
# output predictions to new directory

mkdir ../diamond_output

for i in $(ls prodigal_output/*.faa);do
  x=`basename $i .faa`
  diamond blastp -d /Volumes/data/uniref/uniref90.dmnd -p 20 -q $i -o ../diamond_output/${x}.m8 --salltitles -k 10 --min-score 30 --outfmt 6
done
# the Diamond output, a .m8 file, will have the top 10 (if possible) BLAST hits for each open reading frame

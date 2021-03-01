#!/bin/bash
##############
# Author: Ben Joris
# Created: June 19th, 2020
# Purpose: Rune checkm qa for the general NA cohort
##############

for sample in $(ls SRR313*_checkm/lineage.ms);do
  IFS='_' read -ra samplearray <<< $sample
  bn=`basename $sample .fa`
  checkm qa -t 10 -o 2 $sample ${samplearray[0]}_checkm --file ${samplearray[0]}_qa.txt
done

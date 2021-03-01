#!/bin/bash
##############
# Author: Ben Joris
# Created: June 19th, 2020
# Purpose: Rune checkm lineage_wf for the general NA cohort
##############

for sample in $(ls SRR313*.fa);do
  bn=`basename $sample .fa`
  checkm lineage_wf -t 10 -x fa ${bn}.fa.metabat-bins20 ${bn}_checkm
done

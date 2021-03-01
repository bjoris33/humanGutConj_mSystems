#!/bin/bash
##############
# Author: Tyler Browne, edited by Ben Joris (June 2020)
# Created: September 2019
# Purpose: Run all scripts related to extracting potentially conjugative contigs
  # from the genome annotations
##############

./getContigs.sh

./redoAnnotations.sh

./getContigLength.sh

./totalGeneAndFreq.sh

./conjCount.sh

python tabcreate.py

python conjugative_elements.py

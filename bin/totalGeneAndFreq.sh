#!/bin/bash
##############
# Author: Tyler Browne, edited by Ben Joris (June 2020)
# Created: September 2019
# Purpose: shell wrapper for totalGenes.py and totalFreq.py
##############

for f in ../conjugative_contigs/*.txt; do
  python totalGenes.py "$f"
done
python totalFreq.py

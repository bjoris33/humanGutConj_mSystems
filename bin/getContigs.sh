#!/bin/bash
##############
# Author: Tyler Browne, edited by Ben Joris (June 2020)
# Created: September 2019
# Purpose: Loop through all genomes and run getContigs.py for each
##############

for f in ../genomes/*.fa; do
  python getContigs.py "$f"
done
echo "DONE: getContigs.py"

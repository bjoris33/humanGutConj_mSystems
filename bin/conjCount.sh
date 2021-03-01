#!/bin/bash
##############
# Author: Tyler Browne, edited by Ben Joris (June 2020)
# Created: September 2019
# Purpose: shell wrapper for conjCount.py, conjCountSort.py, and conjCountAndLength.py
##############
# Creates a temporary file to store counts
> ../summary_data/conjCountTemp.txt
# Runs the program conjCount.py on each potential plasmid .txt file
for f in ../conjugative_contigs/*.txt; do
  python conjCount.py "$f"
done
# Creates a new perminent file for the conjugative machinery counts
> ../summary_data/conjCount.txt
# Runs the program conjCountSort.py which sorts the conjCountTemp.txt file and places it in conjCount.txt
python conjCountSort.py
# Removes the temporary file
rm ../summary_data/conjCountTemp.txt
# Runs the program conjCountAndLength.py to obtain length information for each potential plasmid
python conjCountAndLength.py

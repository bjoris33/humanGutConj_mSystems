#!/bin/bash
##############
# Author: Tyler Browne, edited by Ben Joris (June 2020)
# Created: September 2019
# Purpose: shell wrapper for redoAnnotations.py
##############

for f in ../conjugative_contigs/*.contigs; do
  python redoAnnotations.py "$f"
done
echo "DONE: redoAnnotations.py"

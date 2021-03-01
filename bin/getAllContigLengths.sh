#!/bin/bash
##############
# Author: Tyler Browne, edited by Ben Joris (June 2020)
# Created: September 2019
# Purpose: shell wrapper for getContigLength.py
##############

for f in ../genomes/*.fa; do
  python getAllContigLength.py "$f"
done

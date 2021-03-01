#!/bin/bash
##############
# Author: Ben Joris
# Created: January 18th, 2021
# Purpose: Quick script to wrap the execution of mob_typer
##############

for i in $(ls ../genome_set_contigs/*); do
    mob_typer -n 20 -i $i -o ../mob_typer
done
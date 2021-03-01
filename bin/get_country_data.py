'''
Author: Ben Joris
Created: October 24, 2019
    Edited: July 28th, 2020
Purpose: Extract country of origin info from line names and add it to tsv to import into anvio
'''
import glob

countrydict={}
with open("pop_mapping_samples.txt") as meta:
    for line in meta:
        countrydict[line.split("\t")[0]]=line.split("\t")[1]


with open("pop_originalmisc.txt") as miscfh:
    for line in miscfh:
        if "layers" in line:
            with open("pop_newmisc.txt","a") as newfh:
                newfh.write(line.strip()+"\t"+"cohort"+ "\n")
        else:
            with open("pop_newmisc.txt","a") as newfh:
                newfh.write(line.strip()+"\t"+countrydict[line.split("\t")[0].rsplit("_",1)[1]]+"\n")

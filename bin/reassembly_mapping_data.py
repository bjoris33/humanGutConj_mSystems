##############
# Author: Ben Joris
# Created: July 7th, 2020
# Purpose: Take data from bowtie output and create tsv of mapping metrics
##############
import subprocess

subprocess.call(["mkdir","../reassembly_mapping_data/"])

with open("../reassembly_mapping_data/mapping_metrics.tsv","w") as metricfh:
    metricfh.write("sample_id\tcohort\tsingle_align\tmulti_align\ttotal_align\n")

ct=0
with open("general_mapping.out") as genfh:
    for line in genfh:
        ct=ct+1
        if ct == 1:
            with open("../reassembly_mapping_data/mapping_metrics.tsv","a") as metricfh:
                metricfh.write(line.strip()+"\tgeneral\t")
        elif ct == 5:
            with open("../reassembly_mapping_data/mapping_metrics.tsv","a") as metricfh:
                metricfh.write(line.strip().split()[1][1:-2]+"\t")
        elif ct == 6:
            with open("../reassembly_mapping_data/mapping_metrics.tsv","a") as metricfh:
                metricfh.write(line.strip().split()[1][1:-2]+"\t")
        elif ct == 7:
            with open("../reassembly_mapping_data/mapping_metrics.tsv","a") as metricfh:
                metricfh.write(line.strip().split()[0][:-1]+"\n")
            ct=0

with open("infant_mapping.out") as genfh:
    for line in genfh:
        ct=ct+1
        if ct == 1:
            with open("../reassembly_mapping_data/mapping_metrics.tsv","a") as metricfh:
                metricfh.write(line.strip()+"\tinfant\t")
        elif ct == 5:
            with open("../reassembly_mapping_data/mapping_metrics.tsv","a") as metricfh:
                metricfh.write(line.strip().split()[1][1:-2]+"\t")
        elif ct == 6:
            with open("../reassembly_mapping_data/mapping_metrics.tsv","a") as metricfh:
                metricfh.write(line.strip().split()[1][1:-2]+"\t")
        elif ct == 7:
            with open("../reassembly_mapping_data/mapping_metrics.tsv","a") as metricfh:
                metricfh.write(line.strip().split()[0][:-1]+"\n")
            ct=0

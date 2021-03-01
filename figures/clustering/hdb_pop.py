##############
# Author: Ben Joris
# Created: September 15th, 2020
# Purpose: Cluster CLR transformed data with HDBScan and plot with matplotlib
##############

import hdbscan
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import pandas

df=pandas.read_csv("pop_pcx.tsv", sep="\t",header=0)
df1=df[["PC1","PC2","PC3","PC4"]]
clusterer = hdbscan.HDBSCAN(min_cluster_size=15)
clusterer.fit(df1)
for i in range(len(clusterer.labels_)):
    print(str(df1.index[i])+"\t"+str(clusterer.labels_[i]))

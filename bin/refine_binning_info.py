##############
# Author: Ben Joris
# Created: July 7th, 2020
# Purpose: Create data structure that can create Sankey diagram
##############

nobin=0
inbin=0
hqbin=0
lqbin=0
smalllq=0
largelq=0
multihq=0
singlehq=0
hqdict={}
with open("../binning_information/conjugative_bins.tsv") as fh1:
    for line in fh1:
        if "accession" in line:
            continue
        if "N/A" == line.split("\t")[3]:
            nobin=nobin+1
        else:
            inbin=inbin+1
            if float(line.split("\t")[5]) >= 90.0 and float(line.split("\t")[6]) <= 5:
                hqbin=hqbin+1
                hqdict[line.split("\t")[1]+"_"+line.split("\t")[3]]=hqdict.get(line.split("\t")[1]+"_"+line.split("\t")[3],0)+1
            else:
                lqbin=lqbin+1
                if int(line.split("\t")[7]) >= 1000000:
                    largelq=largelq+1
                else:
                    smalllq=smalllq+1

for k,v in hqdict.items():
    if v == 1:
        singlehq=singlehq+1
    else:
        multihq=multihq+v

print("System not in bin:",nobin)
print("System in bin:", inbin)
print("System in high quality bin:",hqbin)
print("System in low quality bin:",lqbin)
print("Multiple systems in one high-quality bin:", multihq)
print("System in one high-quality bin:", singlehq)
print("System in large low-quality bin:", largelq)
print("System in small low-quality bin:", smalllq)

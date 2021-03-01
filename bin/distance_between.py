'''
- Need to establish distribution of distances between relaxases and conjugative operons
- Inform slicing of conjugative systems in gutDB for mapping
'''

import glob

# Regardless of proximity to other orfs of the same types, the flags will be set
# won't necessarily return a list of pure distances between relaxase and T4SS in same operon
# some of the data will be between operons
for file in glob.glob("../summary_data/orf_tables/*.txt"):
    print("Looking at file: ",file)
    t4found=False
    relaxfound=False
    ct=0
    conjlist=[]
    orfnum=0
    with open(file) as fh:
        for line in fh:
            orfnum=orfnum+1
            if "function" in line.split("\t")[13]:
                continue
            if "Type IV" in line.split("\t")[13]:
                t4found=True
            if "Relaxase" in line.split("\t")[13]:
                relaxfound=True
            if t4found and relaxfound:
                with open("relaxase_distance.txt","a") as countfh:
                    countfh.write(str(ct)+"\n")
                    relaxfound=False
                    t4found=False
                    ct=0
            if t4found and "Type IV" in line.split("\t")[13]:
                ct=0
            if relaxfound and "Relaxase" in line.split("\t")[13]:
                ct=0
            if t4found or relaxfound:
                ct=ct+1

# try to find the distance between everything
for file in glob.glob("../summary_data/orf_tables/*.txt"):
    print("Looking at file: ",file)
    onefound=False
    twofound=False
    ct=0
    with open(file) as fh:
        for line in fh:
            if "function" in line.split("\t")[13]:
                continue
            if "Type IV" in line.split("\t")[13] and not onefound:
                onefound=True
            if "Relaxase" in line.split("\t")[13] and not onefound:
                onefound=True
            if "Type IV" in line.split("\t")[13] and onefound:
                twofound=True
            if "Relaxase" in line.split("\t")[13] and onefound:
                twofound=True
            if onefound:
                ct=ct+1
            if onefound and twofound:
                with open("all_dist.txt","a") as countfh:
                    countfh.write(str(ct)+"\n")
                    twofound=False
                    ct=0

##############
# Author: Ben Joris
# Created: September 2019,
    #Edited: July 27th, 2020

import pandas
from collections import defaultdict
import subprocess
import glob

#file="20298_2_49.faa.orfs.fa"
for file in glob.glob("../conjugative_contigs/*.faa.orfs.fa"):
    bn=file.split(".")[0]
    fhcontigs=open("../conjugative_contigs/"bn+".faa.contigs")
    annodict=defaultdict(dict)
    for line in fhcontigs:
        chunks=line.split("\t")
        numorf=chunks[0].rsplit("_",1)[1]
        anno=chunks[1].split(":",1)[1].split(":n=",1)[0].replace(":"," ")
        if anno in ("Uncharacterized:protein", "hypothetical:protein","Uncharacterized:protein:(Fragment)"):
            continue
        annodict[chunks[0]][anno]=annodict[chunks[0]].get(anno,0) + 1
    fhcontigs.close()
    fh=open(file)
    bn=file.split(".")[0]
    orflist=[]
    #content="number"+"\t"+"func"+"\t"+"start"+"\t"+"end"+"\t"+"molecule"+"\t"+"strand"+"\t"+"direction"+"\t"+"name"+"\n"
    for line in fh:
        if ">" in line:
            orfinfo={}
            items=line.split(" # ")
            orfinfo["orfnum"]=items[0].rsplit("_",1)[1]
            orfinfo["start"]=items[1]
            orfinfo["end"]=items[2]
            orfinfo["molecule"]=items[0].rsplit("_",1)[0].split(">",1)[1]
            if int(items[3]) == 1:
                direct="forward"
            else:
                direct="reverse"
            orfinfo["strand"]=direct
            orfinfo["direction"]=items[3]
            orfinfo["function"]="N/A"
            t4ss=False
            t4cp=False
            relax=False
            for key in annodict[items[0].split(">",1)[1]].keys():
                if any(substring in key for substring in ["conjugal transfer protein","Conjugal transfer protein", "TraA","TraB","TraC","TraE","TraF", "TraH","TraK","TraL","TraM","TraN","TraO","TraP","TraQ","TraR","TraS","TraT","TraU","TraV","TraW","TraX","TraY","TraZ","VirB","Type IV","conjugative transfer"]):
                    t4ss=True
                if any(substring in key for substring in ["coupling protein", "traD", "TraD", "TraG", "traG","VirD4","VirD4"]):
                    t4cp=True
                if any(substring in key for substring in ["Mobilization protein", "MobA", "MobC", "Relaxase", "mobilization protein", "relaxase", "TraI", "traI","TraJ","traJ"]):
                    relax=True
            if t4ss is True:
                orfinfo["function"]="Type IV Secretion System"
            if t4cp is True:
                orfinfo["function"]="Type IV Coupling Protein"
            if relax is True:
                orfinfo["function"]="Relaxase/Mobilization Protein"
            l=[]
            for key,val in annodict[items[0].split(">",1)[1]].items():
                l.append((val,key))
            l.sort(reverse=True)
            try:
                orfinfo["anno1"]=l[0][1]
            except:
                orfinfo["anno1"]="N/A"
            try:
                orfinfo["anno2"]=l[1][1]
            except:
                orfinfo["anno2"]="N/A"
            try:
                orfinfo["anno3"]=l[2][1]
            except:
                orfinfo["anno3"]="N/A"
            try:
                orfinfo["anno4"]=l[3][1]
            except:
                orfinfo["anno4"]="N/A"
            try:
                orfinfo["anno5"]=l[4][1]
            except:
                orfinfo["anno5"]="N/A"
            try:
                orfinfo["anno6"]=l[5][1]
            except:
                orfinfo["anno6"]="N/A"
            try:
                orfinfo["anno7"]=l[6][1]
            except:
                orfinfo["anno7"]="N/A"
            try:
                orfinfo["anno8"]=l[7][1]
            except:
                orfinfo["anno8"]="N/A"
            try:
                orfinfo["anno9"]=l[8][1]
            except:
                orfinfo["anno9"]="N/A"
            try:
                orfinfo["anno10"]=l[9][1]
            except:
                orfinfo["anno10"]="N/A"
            orflist.append(orfinfo)

    fh.close()
    #print(orflist)
    df=pandas.DataFrame(orflist)
    newfile="../annotation_tables/"+bn+"_refined.txt"
    df.to_csv(newfile, sep="\t")
    # subprocess.call(["/usr/bin/Rscript", "tabcreate.R", newfile])
#newtxt=open("20298_3_4_refined.txt", "w")
#newtxt.write(content)
#newtxt.close()

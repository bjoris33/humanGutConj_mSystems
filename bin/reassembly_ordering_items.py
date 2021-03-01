#####
# AUTHOR: Ben Joris
# CREATED: January 30th, 2020
    # Revised July 8th, 2020
# PURPOSE: Need to add another items data point to create an ordering to the data for the final figure
####

keyphy={}
with open("../reassembly_anvio/SAMPLES_MERGED/items_new.txt") as fh:
    for line in fh:
        if "item_name" in line:
            continue
        else:
            keyphy[line.split("\t")[0]]=line.split("\t")[1]

print(keyphy)

ordernum=1
orderlist=[]
infantlist=[]

for k,v in keyphy.items():
    if "SRR313" in k:
        infantlist.append((v,k))
infantlist.sort()

adultlist=[]
for k,v in keyphy.items():
    if "SRR5650" in k:
        adultlist.append((v,k))
adultlist.sort()

combinedlist=infantlist+adultlist

with open("../reassembly_anvio/SAMPLES_MERGED/items_order.txt","w") as newfh:
    newfh.write("item_name"+"\t"+"order_vector"+"\n")
    for i in combinedlist:
        newfh.write(i[1]+"\t"+str(ordernum)+"\n")
        ordernum=ordernum+1

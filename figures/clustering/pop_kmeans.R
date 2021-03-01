library(ppclust)
library(zCompositions)
library(factoextra)
library(ggplot2)
library(plyr)
d <- read.table("pop_cov.txt",header = T,row.names = 1, sep = "\t", quote = "",stringsAsFactors = F)
d.clr <- apply(d + 0.4, 2, function(x){log(x) - mean(log(x))})
d.pcx <- prcomp(t(d.clr))
write.table(d.pcx$x,file = "pop_pcx.tsv",sep = "\t",quote = F,col.names = T,row.names = T)
d.fcm <- fcm(t(d.clr), centers=8)
d.fcm2 <- ppclust2(d.fcm, "kmeans")

name.matrix <- read.table("pop_mapping_samples.txt",header = F,stringsAsFactors = F, quote = "",sep = "\t")
name.matrix.ordered <- name.matrix[order(match(name.matrix[,1],colnames(d.clr))),]

fig <- fviz_cluster(d.fcm2, data = t(d.clr), ellipse.type = "norm", palette="jco", repel=T, geom = c("point")) + ggtitle(label = '') + geom_text(aes(label=name.matrix.ordered[,2],hjust=-0.2),size=2) + theme(legend.position = "none")
ggsave("pop_kmeans.pdf",plot=fig,device = "pdf")

name.matrix.subset <- name.matrix.ordered[which(name.matrix.ordered$V2 != "NAPT" & name.matrix.ordered$V2 != "WEI"),]
d.subset <- d[,name.matrix.subset[,1]]
d.clr.subset <- apply(d.subset + 0.4, 2, function(x){log(x) - mean(log(x))})
d.pcx.subset <- prcomp(t(d.clr.subset))
write.table(d.pcx.subset$x,file = "pop_subset_pcx.tsv",sep = "\t",quote = F,col.names = T,row.names = T)
d.fcm.subset <- fcm(t(d.clr.subset), centers=6)
d.fcm2.subset <- ppclust2(d.fcm.subset, "kmeans")
fig2 <- fviz_cluster(d.fcm2.subset, data = t(d.clr.subset), ellipse.type = "norm", palette="jco", repel=T, geom = c("point")) + ggtitle(label = '') + geom_text(aes(label=name.matrix.subset[,2],hjust=-0.2),size=2) + theme(legend.position = "none")
ggsave("pop_kmeans_subset.pdf",plot=fig2,device = "pdf")

##### DO HDB CLUSTERING IN PYTHON ######

hdb <- read.table("hdb_pop_clusters.tsv",sep = "\t",stringsAsFactors = F,quote = "")
col <- character()
for(i in 1:nrow(hdb)){
  if(hdb[i,2] == 0){
    col <- c(col,"blue")
  }
  if(hdb[i,2] == 1){
    col <- c(col,"orange")
  }
  if(hdb[i,2] == 2){
    col <- c(col,"green")
  }
  if(hdb[i,2] == 3){
    col <- c(col,"purple")
  }
  if(hdb[i,2] == -1){
    col <- c(col,"grey")
  }
}

Cohort <- character()
for(i in 1:nrow(name.matrix.subset)){
  if(name.matrix.subset[i,2] == "EA"){
    Cohort <- c(Cohort, "East Asian")
  }
  if(name.matrix.subset[i,2] == "SA"){
    Cohort <- c(Cohort, "South American")
  }
  if(name.matrix.subset[i,2] == "WEG"){
    Cohort <- c(Cohort, "Western European General")
  }
  if(name.matrix.subset[i,2] == "NAG"){
    Cohort <- c(Cohort, "North American General")
  }
  if(name.matrix.subset[i,2] == "WA"){
    Cohort <- c(Cohort, "West African")
  }
  if(name.matrix.subset[i,2] == "NAI"){
    Cohort <- c(Cohort, "North American Indigenous")
  }
}


pcx.df <- as.data.frame(d.pcx$x)
hdbplot <- ggplot(data = pcx.df, aes(x=PC1,y=PC2)) + geom_point(colour=col) + geom_text(aes(label=name.matrix[,2],hjust=-0.2),size=2)
ggsave("pop_hdb.pdf",plot=hdbplot,device = "pdf")

##########

hdb2 <- read.table("hdb_pop_subset_clusters.tsv",sep = "\t",stringsAsFactors = F,quote = "")
col2 <- character()
for(i in 1:nrow(hdb2)){
  if(hdb2[i,2] == 0){
    col2 <- c(col2,"blue")
  }
  if(hdb2[i,2] == 1){
    col2 <- c(col2,"orange")
  }
  if(hdb2[i,2] == 2){
    col2 <- c(col2,"purple")
  }
  if(hdb2[i,2] == 3){
    col2 <- c(col2,"green")
  }
  if(hdb2[i,2] == -1){
    col2 <- c(col2,"grey")
  }
}
pcx.df.subset <- as.data.frame(d.pcx.subset$x)
d.mvar <- sum(d.pcx.subset$sdev^2)
PC1 <- paste("PC1: ", round(sum(d.pcx.subset$sdev[1]^2)/d.mvar, 3))
PC2 <- paste("PC2: ", round(sum(d.pcx.subset$sdev[2]^2)/d.mvar, 3))
hdbplot2 <- ggplot(data = pcx.df.subset, aes(x=PC1,y=PC2,colour=col2)) +
  geom_point(colour=col2, aes(shape=Cohort)) +
#  geom_text(aes(label=name.matrix.subset[,2],hjust=-0.2),size=2, colour="black") + 
  stat_ellipse(data = pcx.df.subset,aes(x=PC1,y=PC2, linetype = col2,colour=col2, fill=col2), geom = "polygon",alpha=0.2, show.legend = FALSE) +
  scale_linetype_manual(values = c(1,0,1,1)) +
  scale_color_manual(values = c("blue","grey","orange","purple")) +
  scale_fill_manual(values = c("blue",NA,"orange","purple")) +
  labs(x=PC1,y=PC2) +
  theme(panel.background = element_blank(),axis.line = element_line(colour = "black",size = 0.5))
ggsave("pop_hdb_subset.pdf",plot=hdbplot2,device = "pdf",width = 10)

test <- ggplot(data = pcx.df.subset, aes(x=PC1,y=PC2, colour=Cohort)) + 
  geom_point(colour=Cohort,show.legend = TRUE) +
  theme(panel.background = element_blank(),axis.line = element_line(colour = "black",size = 0.5))
ggsave("test.pdf",plot=test,device = "pdf")
  
####

d.tab <- as.data.frame(cbind(name.matrix, col))
counts <- ddply(d.tab, .(d.tab$V2,d.tab$col), nrow)
colnames(counts) <- c("Cohort", "Cluster", "Count")
write.table(counts, file="pop_clustering_groups.tsv",quote = F,sep = "\t",row.names = F,col.names = T)

d.tab.subset <- as.data.frame(cbind(name.matrix.subset, col2))
counts.subset <- ddply(d.tab.subset, .(d.tab.subset$V2,d.tab.subset$col2), nrow)
colnames(counts.subset) <- c("Cohort", "Cluster", "Count")
write.table(counts.subset, file="pop_subset_clustering_groups.tsv",quote = F,sep = "\t",row.names = F,col.names = T)

sbplot <- ggplot(counts.subset,aes(fill=Cluster, y=Count,x=Cohort)) + geom_bar(position = "fill", stat = "identity") + scale_fill_manual(values = c("blue","grey","orange","purple"))+theme(legend.position = "none",panel.background = element_blank(),axis.line = element_line(colour = "black",size = 0.5)) + ylab("Proportion of samples belonging to cluster")
ggsave("pop_hdb_sbp.pdf",plot=sbplot,device = "pdf")

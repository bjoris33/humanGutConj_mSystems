library(ppclust)
library(zCompositions)
library(factoextra)
library(ggplot2)
library(plyr)
d <- read.table("aggregated.tsv",header = T,row.names = 1, sep = "\t", quote = "",stringsAsFactors = F)
d.clr <- apply(d + 0.4, 2, function(x){log(x) - mean(log(x))})
write.table(t(d.clr),file = "agg_clr.tsv",sep = "\t",quote = F,col.names = T,row.names = T)
d.pcx <- prcomp(t(d.clr))
write.table(d.pcx$x,file = "agg_pcx.tsv",sep = "\t",quote = F,col.names = T,row.names = T)
d.fcm <- fcm(t(d.clr), centers=2)
d.fcm2 <- ppclust2(d.fcm, "kmeans")

name.matrix <- matrix(ncol = 2, nrow = 101)
name.matrix[,1] <- colnames(d.clr)

for (i in 1:nrow(name.matrix)){
  if (grepl("SRR3131", name.matrix[i,1],fixed = TRUE)){
    name.matrix[i,2] <- "Infant"
  }
  if (grepl("SRR565", name.matrix[i,1],fixed = T)){
    name.matrix[i,2] <- "General"
  }
}

fig <- fviz_cluster(d.fcm2, data = t(d.clr), ellipse.type = "norm", palette="jco", repel=T, geom = "point") + ggtitle(label = '') + geom_text(aes(label=name.matrix[,2],hjust=-0.2),size=2) + theme(legend.position = "none")
ggsave("reassembly_kmeans.pdf",plot=fig,device = "pdf")


##### DO HDB CLUSTERING IN PYTHON ######

hdb <- read.table("hdb_clusters.tsv",sep = "\t",stringsAsFactors = F,quote = "")
col <- character()
for(i in 1:nrow(hdb)){
  if(hdb[i,2] == 0){
    col <- c(col,"blue")
  }
  if(hdb[i,2] == 1){
    col <- c(col,"orange")
  }
  if(hdb[i,2] == -1){
    col <- c(col,"grey")
  }
}
pcx.df <- as.data.frame(d.pcx$x)
d.mvar <- sum(d.pcx$sdev^2)
PC1 <- paste("PC1: ", round(sum(d.pcx$sdev[1]^2)/d.mvar, 3))
PC2 <- paste("PC2: ", round(sum(d.pcx$sdev[2]^2)/d.mvar, 3))
plot(x = d.pcx$x[,1], y = d.pcx$x[,2])
Cohort=name.matrix[,2]
hdbplot <- ggplot(data = pcx.df, aes(x=PC1,y=PC2,colour=col)) + 
  geom_point(colour=col, aes(shape=Cohort)) + 
#  geom_text(aes(label=name.matrix[,2],hjust=-0.2),size=2, colour="black") + 
  stat_ellipse(aes(linetype = col, colour=col, fill=col), geom = "polygon",alpha=0.2, show.legend = FALSE) + 
  scale_linetype_manual(values = c(1,0,1))+ 
  scale_color_manual(values = c("blue","grey","orange"))+ 
  scale_fill_manual(values = c("blue",NA,"orange")) + 
  labs(x=PC1,y=PC2)+
  theme(panel.background = element_blank(),axis.line = element_line(colour = "black",size = 0.5))+ xlim(-50,50)+ylim(-50,50)
ggsave("reassembly_hdb.pdf",plot=hdbplot,device = "pdf")


d.tab <- as.data.frame(cbind(name.matrix, col))
counts <- ddply(d.tab, .(d.tab$V2,d.tab$col), nrow)
colnames(counts) <- c("Cohort", "Cluster", "Count")
write.table(counts, file="reassembly_clustering_groups.tsv",quote = F,sep = "\t",row.names = F,col.names = T)

sbplot <- ggplot(counts,aes(fill=Cluster, y=Count,x=Cohort)) + geom_bar(position = "fill", stat = "identity") + scale_fill_manual(values = c("blue","grey","orange"))+theme(legend.position = "none",panel.background = element_blank(),axis.line = element_line(colour = "black",size = 0.5))+ ylab("Proportion of samples belonging to cluster")
ggsave("reassembly_hdb_sbp.pdf",plot=sbplot,device = "pdf")



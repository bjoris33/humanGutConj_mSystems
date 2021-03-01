library(ggplot2)
library(gggenes)

args <- commandArgs(TRUE)
fn <- args[[1]]
bn <- strsplit(fn, ".txt")

d <- read.table(fn, sep="\t", header = T, stringsAsFactors = F, quote = "")
d.ordered <- d[,c("orfnum","molecule","start","end","strand","direction","function.","anno1","anno2","anno3","anno4","anno5","anno6","anno7","anno8","anno9","anno10")]
d.split <- split.data.frame(d.ordered, f=d.ordered$molecule)

plotlist <- list()
for(i in 1:length(d.split)){
  tempdf <- as.data.frame(d.split[i])
  tempfn <- paste(bn,"_",i,".txt",sep="")
  colnames(tempdf)<-colnames(d.ordered)
  write.table(tempdf, tempfn, quote = F, sep = "\t")
  strt <- min(which(tempdf$function. != "N/A")-5)
  if(strt < 1){
    strt <- 1
  }
  temp.reduced <- tempdf[strt:(max(which(tempdf$function. != "N/A"))+5),]
  plot <- ggplot(temp.reduced,aes(xmin=start,xmax=end,y=i,fill=function.,label=orfnum,forward=direction))+geom_gene_arrow()+geom_gene_label(align="left")+facet_wrap(~ molecule, scales = "free", ncol = 1)+scale_fill_brewer(palette = "Set3")
  plotlist[[i]] <- plot

}

for(i in 1:length(d.split)){
  filename <- paste(bn, "_",i,".map",".pdf",sep="")
  pdf(filename, height=7,width=20, useDingbats=F, onefile=TRUE)
  print(plotlist[[i]])
  dev.off()
}

# boxplot generation
library(ggplot2)
d <- read.table("metrics.txt", sep = "\t", header = T, stringsAsFactors = F,quote = "")
bp <- ggplot(d, aes(x=cohort, y=total_percent_mapped,fill=cohort)) + geom_boxplot() + scale_fill_manual(values=alpha(c("#ff9c40","#d96ca8","#54a4f0","#3a21db","#aeeb8a","#015e20","#8d2eb3","#b83d0d"),.7)) + labs(x="Cohort",y="Percentage of reads mapping to conjugative regions") +theme(axis.text = element_text(size = 10),legend.position = "none", axis.title = element_text(size = 15),axis.text.x = element_text(margin = margin(r=10,l=10)),axis.title.y = element_text(margin = margin(r=20)), axis.line = element_line(colour = "black",size = 0.5),panel.background = element_blank()) + geom_jitter(shape=16, position = position_jitter(0.2)) + scale_x_discrete(labels=c("West African","East Asian", "Western European", " Western European\nInfants", "North American", "North American\nIndigenous", "North American\nPre-term Infants", "South American"))
ggsave("figure_1b.png", device = "png", width = 12)
d2 <- read.table("mapping_metrics.tsv", sep = "\t", header = T, stringsAsFactors = F,quote = "",row.names = NULL)
bp2 <-ggplot(d2, aes(x=cohort, y=total_align,fill=cohort)) + geom_boxplot() + scale_fill_manual(values=alpha(c("#1e10e6","#d47800"),0.7)) + labs(x="Cohort",y="Percentage of reads mapping to conjugative regions") +theme(legend.position="none",axis.text = element_text(size = 12), axis.title = element_text(size = 15),axis.title.y = element_text(margin = margin(r=20)),axis.line = element_line(colour = "black",size = 0.5),panel.background = element_blank()) + geom_jitter(shape=16, position = position_jitter(0.2)) + scale_x_discrete(labels=c("Pre-term Infants", "General Population"))
ggsave("figure_2b.png", device = "png", scale = 2)

d3<-data.frame()
for(i in 1:nrow(d)){
  temp<-data.frame()
  if(d[i,3] == "north_america"){
    temp<- data.frame(Cohort="Genome Set\nGeneral North American", Percentage=d[i,8])
  }
  if(d[i,3] == "north_america_infants"){
    temp<- data.frame(Cohort="Genome Set\nNorth American Pre-term Infants", Percentage=d[i,8])
  }
  d3<-rbind(d3,temp)
}
for(i in 1:nrow(d2)){
  temp<-data.frame()
  if(d2[i,2] == "general"){
    temp<- data.frame(Cohort="De novo assembled\nGeneral North American", Percentage=d2[i,5])
  }
  if(d2[i,2] == "infant"){
    temp<- data.frame(Cohort="De novo assembled\nNorth American Pre-term Infants", Percentage=d2[i,5])
  }
  d3<-rbind(d3,temp)
}
bp3 <- ggplot(d3, aes(x=Cohort, y=Percentage,fill=Cohort)) +
  geom_boxplot() +
  scale_fill_manual(values=alpha(c("#ff9c40","#d96ca8","#54a4f0","#3a21db"),.7)) +
  labs(x="Cohort",y="Percentage of reads mapping to conjugative regions") +
  theme(axis.text = element_text(size = 10),legend.position = "none", axis.title = element_text(size = 15),axis.text.x = element_text(margin = margin(r=10,l=10)),axis.title.y = element_text(margin = margin(r=20)), axis.line = element_line(colour = "black",size = 0.5),panel.background = element_blank()) + geom_jitter(shape=16, position = position_jitter(0.2)) +
  #scale_x_discrete(labels=c("Genome Set\nGeneral North American", "Genome Set\nNorth American Pre-term Infants","De novo assembled\nGeneral North American","De novo assembled\nNorth American Pre-term Infants"))
ggsave("figure_7.png", device = "png", scale = 1.5)


# Separating abundances of cohorts
d.infant <- as.data.frame(d[which(d$cohort == "north_america_infants"),8])/100
d.adult <- as.data.frame(d[which(d$cohort == "north_america"),8])/100
d2.adult <- as.data.frame(d2[which(d2$cohort == "general"),5])/100
d2.infant <- as.data.frame(d2[which(d2$cohort == "infant"),5])/100


# Infant CLR CI
d.infant.clr <- apply(d.infant,2, function(x){log(x) - mean(log(x))})
exp(mean(log(d.infant[,1])))
exp(mean(log(d.infant[,1])) + quantile(d.infant.clr, probs=c(0.025,0.5,0.975)))

# Adult CLR CI
d.adult.clr <- apply(d.adult,2, function(x){log(x) - mean(log(x))})
exp(mean(log(d.adult[,1])))
exp(mean(log(d.adult[,1])) + quantile(d.adult.clr, probs=c(0.025,0.5,0.975)))

# Infant2 CLR CI
d2.infant.clr <- apply(d2.infant+0.00001,2, function(x){log(x) - mean(log(x))})
exp(mean(log(d2.infant[,1]+0.00001)))
exp(mean(log(d2.infant[,1]+0.00001)) + quantile(d2.infant.clr, probs=c(0.025,0.5,0.975)))

# Adult2 CLR CI
d2.adult.clr <- apply(d2.adult,2, function(x){log(x) - mean(log(x))})
exp(mean(log(d2.adult[,1])))
exp(mean(log(d2.adult[,1])) + quantile(d2.adult.clr, probs=c(0.025,0.5,0.975)))


##

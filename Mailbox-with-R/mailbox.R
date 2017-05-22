# Install libraries
install.packages("tm.plugin.mail")
install.packages("tm")
install.packages("sqldf")
install.packages("tidyr")
install.packages("dplyr")
install.packages("rgexf")
install.packages("igraph")
install.packages("ggplot2")
install.packages("lubridate")
install.packages('GGally')

library(sqldf)
library(tidyr)
library(plyr)
library(dplyr)
library(rgexf)
library(igraph)
library(rgexf)
library(tm.plugin.mail)
library(ggplot2)
library(lubridate)
library("tm")
library("tm.plugin.mail")
library("RColorBrewer")
library("wordcloud")
library("stringi")
library("tidyverse")
library('GGally')
library('scales')
detach("package:sna", unload=TRUE)
detach("package:network", unload=TRUE)
detach("package:intergraph", unload=TRUE)

#Setup working directory
#With OSX, it does work but setting up a path under Win7 can be a pain in the ass
#setwd("/home/ascyber/Documents/mails/")

#If you have a mailbox file instead of eml files
#Uncomment the following lines to convert the mb file to a list of eml files
# mbf <- "nom_du_fichier_mbox"
# convert_mbox_eml(mbf, "efichier_eml")

#read mails
maildir <- setwd("/home/herve/MailEIJC17/Mailbox-with-R/mails")
mailfiles <- dir(maildir, full.names=FALSE)
Encoding(mailfiles)  <- "UTF-8"
#Read mails one by one via a function "readmsg" that parses senders, subjects, timestamps and receivers

readmsg <- function(fname) {
  l <- readLines(fname) 
  origin <- grep('^From:', l, value=TRUE)
  origin < gsub("From:", "", origin)
  dest <- grep("^To:", l, value=TRUE)
  dest <- gsub("To:", "", dest)
  date <- grep("^Date:", l, value=TRUE)
  date <- gsub("Date:", "", date)
  subj <- grep("^Subject:", l, value=TRUE)
  subj <- gsub("Subject:", "", subj)
  return(c(origin, dest, date, subj))
}
#Creation of the dataframe
mdf <- do.call(rbind, lapply(mailfiles, readmsg))
tableau <- as.data.frame(mdf)
#Table is messy, so we only collect the useful columns
tableau <- tableau[1:4]
colnames(tableau) <- c("Source", "Target", "Date", "Sujet")
#Some cleansing on the table
tableau_temp <- tableau
tableau_temp$Target <- gsub('.*\\"',"", tableau_temp$Target)
tableau_temp$Target <- gsub("*>.*", "", tableau_temp$Target)
tableau_temp$Target <- gsub(".*<","", tableau_temp$Target)
tableau_temp$Target <- casefold(tableau_temp$Target, upper = FALSE)
tableau_temp$Source <- gsub("*>.*", "", tableau_temp$Source)
tableau_temp$Source <- gsub(".*<","", tableau_temp$Source)
tableau_temp$Source <- gsub("\"","", tableau_temp$Source)
tableau_temp$Target <- gsub("\"","", tableau_temp$Target)
tableau_temp$Source <- gsub("From: ","", tableau_temp$Source)
tableau_temp$Source <- trimws(tableau_temp$Source)
tableau_temp$Target <- trimws(tableau_temp$Target)
#temporary table becomes the main one
tableau<-tableau_temp
#Split multivalued cells with tidyr 
tableau<-tableau %>% unnest(Target=strsplit(Target, ","))
#reorder columns
tableau <- tableau[c("Source", "Target", "Date", "Sujet")]
#delete empty rows
tableau <- tableau[!apply(tableau, 1, function(x) any(x=="")),]
#creation of the gexf file
#simplification of the table. Graph wil be directed as we have a sender and recipents
reseau<-simplify(graph.data.frame(tableau, directed =TRUE))
# #creation of nodes
nodes_reseau <- data.frame(ID=c(1:vcount(reseau)), NAME=V(reseau)$name)
# #creation of edges
edges_reseau <- as.data.frame(get.edges(reseau, c(1:ecount(reseau))))
# #now comes the gexf file that you can re-vamp with Gephi for instance
write.gexf(nodes = nodes_reseau, edges = edges_reseau, defaultedgetype = "directed", output ="../Output/network.gexf")

library('sna')

# playing with graphs directly in R
net_reseau  network(nodes_reseau, )
#Compute some metrics like modularity, betweenness centrality
cw <- cluster_walktrap(net_reseau)
net.com <- modularity(net_reseau, membership(cw))
net.deg <- centralization.degree(net_reseau)$res
net.bet <- edge_betweenness(net_reseau, e = E(net_reseau), directed = TRUE, weights = NULL)
graphDef <- (net_reseau, size = net.deg, mode ="fruchtermanreingold", layout.par = list(cell.jitter = 0.75),  label = nodes_reseau$NAME, layout.exp = 0) + guides(color = FALSE, size = FALSE)
graphDef <- graphDef + ggtitle(paste("Mailbox relashionship"))
graphDef <- graphDef + guides(title.position="top")
#Export graph as pdf
pdf(file=paste('filename','.pdf', sep =''), width = 14, height = 10, pointsize = 2)
par(mar=c(10,10,10,10)+0.1)
graphDef
dev.off()
#Export graph as svg for post production
svg(file=paste('filename','.svg', sep =''), width = 14, height = 10)
par(mar=c(10,10,10,10)+0.1)
graphDef
dev.off()



# A few stats using ggplot and sqldf
comptage_exp <- sqldf('select Source, count(*) from tableau where Source is not null group by Source ORDER BY count(*) DESC')
names(comptage_exp)[names(comptage_exp)=="count(*)"] <- "Nombre"
comptage_dest <- sqldf('select Target, count(*) from tableau where Target is not null group by Target ORDER BY count(*) DESC')
names(comptage_dest)[names(comptage_dest)=="count(*)"] <- "Nombre"

# Graph based on From field
g_compt_exp <- ggplot(comptage_exp, aes(x = reorder(Source, Nombre), y= Nombre, fill = Nombre))
g_compt_exp + geom_bar(stat = "identity") + coord_flip() + ggtitle("Senders by emails sent") + xlab("Senders") + ylab("Emails sent") + theme(plot.title = element_text(size = 16, face = "bold", family = "Calibri"), axis.title=element_text(face="bold", size=8, color="black"))

# Graph based on To field
g_compt_dest <- ggplot(comptage_dest, aes(x = reorder(Target, Nombre), y= Nombre, fill = Nombre))
g_compt_dest + geom_bar(stat = "identity") + coord_flip() + ggtitle("Recepients by email sent") + xlab("Recepients") + ylab("Emails sent") + theme(plot.title = element_text(size = 16, face = "bold", family = "Calibri"), axis.title=element_text(face="bold", size=8, color="black"))

# Graph based on Domain
domain_exp <- separate(data = comptage_exp, col = Source, into = c("ID_exp", "Domain"), sep = "@")
domain_exp<- sqldf('select Domain, count(*) from domain_exp where Domain is not null group by Domain ORDER BY count(*) DESC')
names(domain_exp)[names(domain_exp)=="count(*)"] <- "Nombre"
g_domain_exp <- ggplot(domain_exp, aes(x = reorder(Domain, Nombre), y= Nombre, fill = Nombre))
g_domain_exp + geom_bar(stat = "identity") + coord_flip() + ggtitle("Domain/emails sent") + xlab("Domain") + ylab("Emails sent") + theme(plot.title = element_text(size = 16, face = "bold", family = "Calibri"), axis.title=element_text(face="bold", size=8, color="black"))

#Some temporality work, like frequency of mails

mailfilesDate <- dir(maildir ,full.names=TRUE)

Encoding(mailfilesDate) <- "UTF-8"
readmsg <- function(fname){
  l <- readLines(fname)
  date <- grep("Date", l, value=TRUE)
  date <- stri_extract_all_regex(date, "[0-9]{1,2}\\s[A-Za-z]{3}\\s[0-9]{4}")
  date <- grep("[0-9]{1,2}\\s[A-Za-z]{3}\\s[0-9]{4}", date, value=TRUE)
  return(c(date))
}
mdf2 <- do.call(rbind, lapply(mailfilesDate, readmsg))
tableau_date1 <- as.data.frame(mdf2)
Sys.setlocale("LC_ALL", "en_US.UTF-8")
tableau_date1$V1 <- as.Date(tableau_date1$V1, format="%d %B %Y")
tableau_date1$V1 <- format(tableau_date1$V1, "%Y/%m")
tableau_date2 <- sqldf("select count(V1) as nb, V1 as date from tableau_date1 group by date order by nb desc")
tableau_date2 <- sqldf(c("delete from tableau_date2 where nb < 1", "select * from tableau_date2"))
ggplot(data=tableau_date2, aes(x=date, y=nb)) + geom_bar(stat="identity", fill="steelblue") + geom_text(aes(label=nb), color="white", size=3, vjust=2) + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))


# Let's free some memory before doing some text mining.

gc(verbose = FALSE)

#Gestion of a corpus

myC <- Corpus(DirSource(maildir), readerControl = list(reader = readMail()))
#Remove some useless and recurring text in mails
i <- 0
while (i < length(myC)){
  i <- i + 1
  myC[[i]] <- removeSignature(myC[[i]])
  myC[[i]] <- removeCitation(myC[[i]])
  myC[[i]] <- removeMultipart(myC[[i]])
}
#Remove punctuation
myC = tm_map(myC, stripWhitespace)
myC = tm_map(myC, removePunctuation)
myC = tm_map(myC, removeNumbers)
myC <- tm_map(myC, removeWords, stopwords("english"))
myC <- tm_map(myC, removeWords, stopwords("french"))

sub <- c()
i <- 0
while (i < length(myC)){
  i <- i + 1
  sub <- append(sub, unlist(strsplit(tolower(iconv(myC[[i]], to="UTF8")), " ")))
}
#creation of a personal dictionnary of useless words, especially html tags...
mot <- c("helvet", "arial", "block", "img", "spac", "3d", "padd", "div", "none", "color", "fontsize", "solid", "targetblank",
         "valigntop", "px", "width", "left","style","family","align","center",
         "height","margin","serif","weight","bordy","html","background",
         "span","title","blank","content","border","exactly","bold","thumbnail","inline","textdecoration","tabletd","th",
         "head","collapse","display", "td","locked","false", "unhide","png","unsubscribe","alt","right","design", "fxrap",
         "body", "agrave", "priority", "class", "fff", "wp", "top", "http", "named", "medium", "adjust", "template",
         "strong", "hidden", "middle", "nbsp", "css", "font", "doctype", "<", ">", "=", "justify", "--", "rgb", "pt;", "guest",
         "text-decoration", "important", "table")

i <- 0
while (i < length(mot)){
  i <- i + 1
  sub <- gsub(sprintf(".*%s.*",mot[i]), "", sub)
}

sub <- sub[sub != ""]

sub <- as.data.frame(sub)

sub <- sqldf("select count(*) as ctr, sub from sub group by sub")

sub <- sqldf(c("delete from sub where sub like '%aa%'", "select * from sub"))

sub <- sqldf(c("delete from sub where sub like '%dd%'", "select * from sub"))

sub <- sqldf(c("delete from sub where length(sub) < 3 or length(sub) > 20", "select * from sub"))

set.seed(4363) 
wordcloud(words=sub$sub, freq=sub$ctr, scale=c(4, 0.5), random.order=FALSE, max.words = 200, colors=brewer.pal(8, "Dark2"), min.freq=1)


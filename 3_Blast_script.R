#See if our package are installed in cluster (first step in cluster)
#system.file(package=c('rBLAST'))
#[1] "/home/fabricio/R/x86_64-pc-linux-gnu-library/4.3/rBLAST"  <- Installed
#system.file(package=c('rBLAST'))
#[1] ""                                                         <- Not installed

library(plyr)
#Install packages from CRAN
pack <- c('dplyr', 'tibble','devtools')
vars <- pack[!(pack %in% installed.packages()[, "Package"])]
if (length(vars != 0)) {
  install.packages(vars, dependencies = TRUE)
}


#Install Biostrings from Bioconductor
BiocManager::install(c("Biostrings"), force = T)
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

#Install rBLAST from github
devtools::install_github("mhahsler/rBLAST")

#Load all required packages
pack <- c('dplyr', 'tibble','devtools','Biostrings','rBLAST')
sapply(pack, require, character.only = TRUE)

#Test

#See the dirctory
getwd()

#set the directory
setwd("/home/fabricio/rBlast")

#Load our novaseq dataset
dna <- readDNAStringSet('testID_ourdata.fasta', format='fasta')

#Select our local database
bl <- blast(db="/home/fabricio/rBlast/local_database/testID_database.fasta")

#Blast with local database
cl <- predict(bl, dna)

#Separate only the max value of match per ZOTU
cl.max <- cl %>% group_by(QueryID) %>% top_n(1,Perc.Ident)

#Blast with ID dataset
Match <- match_df(ID, cl.max, on="SubjectID")
Match <- cbind(QueryID = cl.max$QueryID, Match)


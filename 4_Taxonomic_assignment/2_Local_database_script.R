#Install packages from CRAN
pack <- c('ape','data.table') #'adegenet'
vars <- pack[!(pack %in% installed.packages()[, "Package"])]
if (length(vars != 0)) {
  install.packages(vars, dependencies = TRUE)
}

#Load all required packages
sapply(pack, require, character.only = TRUE)

#See the dirctory
setwd("C:/Users/Alícya/Desktop/Taxonomic_assignment_novaseq/local_database")
#setwd("/cluster/projects/nn9813k/Brazil/January_2023/NovaSeq/Sample_2-PL02-Leray/Final_Results/Taxonomic_assignment_novaseq/local_database")

#Load our database 
local_database <- fread("local_database_raw.txt", fill = T)
#local_database <- fread("BOLD_Public.txt", fill = T)

#select only relevant cols
#local_database_filter_0 <- local_database[,c(10:18,52)] #BOLD_Public_A_1_1
#local_database_filter_1 <- local_database[,c(10:18,52)] #BOLD_Public_A_1_2
#local_database_filter_2 <- local_database[,c(10:18,52)] #BOLD_Public_A_2_1
#local_database_filter_3 <- local_database[,c(10:18,52)] #BOLD_Public_A_2_2
#local_database_filter_4 <- local_database[,c(10:18,52)] #BOLD_Public_B_1_1
#local_database_filter_5 <- local_database[,c(10:18,52)] #BOLD_Public_B_1_2
#local_database_filter_6 <- local_database[,c(10:18,52)] #BOLD_Public_B_2_1
#local_database_filter_7 <- local_database[,c(10:18,52)] #BOLD_Public_B_2_2

#sl <- object.size(local_database_filter)
#print(sl, units = "MB", standard = "SI")

#rm(local_database)

#local_database_filter <- data.frame(rbind(local_database_filter_0,local_database_filter_1,local_database_filter_2,
#                                          local_database_filter_3,local_database_filter_4,local_database_filter_5,
#                                          local_database_filter_6,local_database_filter_7)) 

#                                        rm(c(local_database_filter_0,local_database_filter_1,local_database_filter_2,
#                                             local_database_filter_3,local_database_filter_4,local_database_filter_5,
#                                             local_database_filter_6,local_database_filter_7))


local_database_filter <- local_database[,c(10:18,52)]

##Convert our local database: txt format >>> fasta format

#Separate the Taxa identification
local_database_fasta <- list()
First_element <- c("Filled","only", "to", "create", "a", "vector")
Second_element <- c("Filled","only", "to", "create", "a", "vector")
for (i in seq(nrow(local_database_filter))) {
First_element <- ">"
Second_element[i] <- paste0(c(local_database_filter[i,1:9]), sep = ",", collapse = "")
Second_element[i] <- substr(Second_element[i], 1, nchar(Second_element[i])-1)
local_database_fasta[[i]] <- capture.output(cat(cat(First_element, Second_element[i])))
}

#Separate the IDs + Taxa identification
ID <- data.frame(SubjectID = paste("ID-", seq(local_database_fasta), sep = ""), Taxa_Identification = Second_element)

write.table(ID, file = "ID_taxa.txt", sep = " ", row.names = F, col.names = T)

#Create a Id to concatenate with our sequences
local_database_ID <- list()
Second_element <- c("Filled","only", "to", "create", "a", "vector")
for (i in seq(nrow(local_database_filter))) {
  Second_element[i] <-  paste(">ID-", i, sep = "")
  local_database_ID[[i]] <- capture.output(cat(cat(Second_element[i])))
}

#Separate the DNA sequences
local_dna_fasta <- list()
Third_element <- c("Filled","only", "to", "create", "a", "vector")
for (i in seq(nrow(local_database_filter))) {
  Third_element[i] <- paste0(c(local_database_filter[i,10]), sep = "", collapse = "")
  local_dna_fasta[[i]] <- capture.output(cat(Third_element[i]))
}

#Merge the taxa names + sequences (In fasta format)
#local_database_TAXA_fasta <- list(local_database_fasta,tolower(local_dna_fasta))

#Merge the taxa names + sequences
local_database_ID_fasta <- list(local_database_ID,tolower(local_dna_fasta))

write.table(sapply(local_database_ID_fasta,"[",c(1:length(local_database_ID_fasta[[1]]))),
            file = "testID_database.fasta", sep = "\n", eol = "\n", row.names = F, col.names = F,
            qmethod = "escape", quote = F)

#To see if the fasta sequences are being imported correctly (OPTIONAL)
#obj <- fasta2DNAbin("testID.fasta", chunk=10)

#Create a local database - Linux (MANDATORY)
#makeblastdb -in testID_database.fasta -parse_seqids -blastdb_version 5 -title "test" -dbtype nucl


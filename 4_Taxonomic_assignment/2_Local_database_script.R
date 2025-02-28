################################################################################
# Impacts of Replicates, Polymerase, and Amplicon Size on Unraveling Species Richness
# Across Habitats Using eDNA Metabarcoding
#
# Authors: Anmarkrud, J.A.; Thorbek, L.; Schrøder-Nielsen, A.; Rosa, F.A.S.; Melo, S.;
# Ready, J.S.; de Boer, H.; Mauvisseau, Q.
#
# Corresponding Author: Quentin Mauvisseau - quentin.mauvisseau@nhm.uio.no
################################################################################

# Load required packages (install missing ones if necessary)
required_packages <- c("ape", "data.table")  
missing_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]

if (length(missing_packages) > 0) {
  install.packages(missing_packages, dependencies = TRUE)
}

sapply(required_packages, require, character.only = TRUE)

# Set Working Directory
setwd("C:/Users/Alícya/Desktop/Taxonomic_assignment_novaseq/local_database")

# Load Local Database
local_database <- fread("local_database_raw.txt", fill = TRUE)
local_database_filter <- local_database[, c(10:18, 52)]

# Convert Local Database to FASTA Format
local_database_fasta <- vector("list", nrow(local_database_filter))
local_database_ID <- vector("list", nrow(local_database_filter))
local_dna_fasta <- vector("list", nrow(local_database_filter))

for (i in seq_len(nrow(local_database_filter))) {
  local_database_fasta[[i]] <- paste0(">", paste(local_database_filter[i, 1:9], collapse = ","))
  local_database_ID[[i]] <- paste0(">ID-", i)
  local_dna_fasta[[i]] <- tolower(as.character(local_database_filter[i, 10]))
}

# Save ID and Taxa Identifications
ID_table <- data.frame(
  SubjectID = paste0("ID-", seq_along(local_database_fasta)),
  Taxa_Identification = unlist(local_database_fasta)
)

write.table(ID_table, file = "ID_taxa.txt", sep = " ", row.names = FALSE, col.names = TRUE, quote = FALSE)

# Merge headers and sequences into FASTA format
local_database_ID_fasta <- c(local_database_ID, local_dna_fasta)

write.table(
  unlist(local_database_ID_fasta),
  file = "testID_database.fasta",
  sep = "\n", row.names = FALSE, col.names = FALSE, quote = FALSE
)

################################################################################
# Create Local BLAST Database (Linux)
################################################################################
# Run this command in the terminal:
# makeblastdb -in testID_database.fasta -parse_seqids -blastdb_version 5 -title "test" -dbtype nucl

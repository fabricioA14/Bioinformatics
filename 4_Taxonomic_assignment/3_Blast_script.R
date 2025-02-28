################################################################################
# Impacts of Replicates, Polymerase, and Amplicon Size on Unraveling Species Richness
# Across Habitats Using eDNA Metabarcoding
#
# Authors: Anmarkrud, J.A.; Rosa, F.A.S.; Thorbek, L.; Schrøder-Nielsen, A.; Melo, S.;
# Ready, J.S.; de Boer, H.; Mauvisseau, Q.
#
# Corresponding Author: Quentin Mauvisseau - quentin.mauvisseau@nhm.uio.no
################################################################################

# It installs and loads the required packages, prepares the working environment, 
# and performs local BLAST analysis with taxonomic assignment.

# Install packages from CRAN if missing
required_packages <- c("plyr","dplyr", "tibble", "devtools", "readr")
missing_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]

if (length(missing_packages) > 0) {
  install.packages(missing_packages, dependencies = TRUE)
}

# Install Biostrings from Bioconductor
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}
BiocManager::install("Biostrings", force = TRUE)

# Install rBLAST from GitHub
devtools::install_github("mhahsler/rBLAST")

# Load all required packages
all_packages <- c("dplyr", "tibble", "devtools", "Biostrings", "rBLAST", "readr")
sapply(all_packages, require, character.only = TRUE)

################################################################################
# Set Up Environment and Perform Local BLAST
################################################################################

# Set working directory
setwd("/home/fabricio/rBlast")

# Load dataset
dna <- readDNAStringSet("testID_ourdata.fasta", format = "fasta")

# Select local database
bl <- blast(db = "/home/fabricio/rBlast/local_database/testID_database.fasta")

# Run BLAST against the local database
cl <- predict(bl, dna)

# Select only the best match (highest percentage identity) per ZOTU
cl.max <- cl %>% group_by(QueryID) %>% top_n(1, Perc.Ident)

# Match BLAST results with database IDs
Match <- match_df(ID, cl.max, on = "SubjectID")
Match <- cbind(QueryID = cl.max$QueryID, Match)

################################################################################
# Save Taxonomic Assignment Results
################################################################################

# Define output file name
output_file <- "taxonomic_assignment.txt"

# Save as tab-separated text file
write_tsv(Match, file = output_file)


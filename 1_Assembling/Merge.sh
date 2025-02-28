################################################################################
# Impacts of Replicates, Polymerase, and Amplicon Size on Unraveling Species Richness
# Across Habitats Using eDNA Metabarcoding
#
# Authors: Anmarkrud, J.A.; Thorbek, L.; Schrøder-Nielsen, A.; Rosa, F.A.S.; Melo, S.;
# Ready, J.S.; de Boer, H.; Mauvisseau, Q.
#
# Corresponding Author: Quentin Mauvisseau - quentin.mauvisseau@nhm.uio.no
################################################################################

# This script is designed for LINUX CLUSTER environments.
# It loads the required module for PEAR, merges paired-end reads, and 
# prepares the data for further analysis.

################################################################################
# Step 1: Load Required Module for PEAR (Paired-End Read Merger)
################################################################################

# Load the PEAR (Paired-End reAd merger) module from the cluster’s environment.
# PEAR is used for merging overlapping paired-end sequencing reads.
module load PEAR/0.9.11-GCCcore-9.3.0

################################################################################
# Step 2: Merge Paired-End Reads
################################################################################

# The `pear` command merges paired-end reads from forward (R1) and reverse (R2) FASTQ files.
# It creates a single file containing merged sequences with higher accuracy.
pear -f 2-PL02-Leray_S2_R1_001.fastq.gz \  # Forward read (R1)
     -r 2-PL02-Leray_S2_R2_001.fastq.gz \  # Reverse read (R2)
     -o merged.fastq                        # Output merged reads file

################################################################################
# Explanation of `pear` Command Options:
#
# - `-f <file>`  : Specifies the forward read (R1) input file.
# - `-r <file>`  : Specifies the reverse read (R2) input file.
# - `-o <file>`  : Defines the output filename (merged paired-end reads).
#
# PEAR automatically detects overlaps and merges paired-end reads into a 
# single high-quality sequence, improving downstream taxonomic assignment.
################################################################################

echo "Paired-end read merging completed. Output: merged.fastq"


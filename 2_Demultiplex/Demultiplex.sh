################################################################################
# Impacts of Replicates, Polymerase, and Amplicon Size on Unraveling Species Richness
# Across Habitats Using eDNA Metabarcoding
#
# Authors: Anmarkrud, J.A.; Rosa, F.A.S.; Thorbek, L.; Schrøder-Nielsen, A.; Melo, S.;
# Ready, J.S.; de Boer, H.; Mauvisseau, Q.; de Boer, H.
#
# Corresponding Author: Quentin Mauvisseau - quentin.mauvisseau@nhm.uio.no
################################################################################

# This script is designed for LINUX CLUSTER environments.
# It loads OBITools, demultiplexes merged reads based on a mapping file, 
# and assigns reads to their corresponding sample.

################################################################################
# Step 1: Load Required Module for OBITools
################################################################################

# Load the OBITools module from the cluster environment.
# OBITools is used for processing and analyzing metabarcoding sequencing data.
module load StdEnv OBITools/1.2.13-GCCcore-11.2.0

################################################################################
# Step 2: Demultiplexing Reads Using `ngsfilter`
################################################################################

# The `ngsfilter` command assigns reads to samples based on a mapping file.
# It allows for up to 2 errors (-e 2) in the barcode sequences.
ngsfilter -t mapping_file_Leray_example.txt \  # Mapping file containing sample barcodes
          -u unidentified_seq.fasta \       # Output file for unassigned sequences
          -e 2 \                            # Allow up to 2 mismatches in barcodes
          merged.fastq.assembled.fastq > merged_demultiplexed.fastq  # Input & Output files

################################################################################
# Explanation of `ngsfilter` Command Options:
#
# - `-t <file>`  : Specifies the mapping file with sample barcodes.
# - `-u <file>`  : Saves unassigned reads in a separate FASTA file.
# - `-e <int>`   : Defines the maximum allowed mismatches in barcode sequences (default: 2).
# - `input.fastq > output.fastq` : Takes the merged FASTQ file as input and 
#   outputs demultiplexed reads assigned to samples.
#
# This step is crucial for properly assigning sequencing reads to their correct
# sample before further analysis.
################################################################################


#!/bin/bash

#SBATCH --account=nn9813k
#SBATCH --job-name=ngsfilter
#SBATCH --partition=bigmem
#SBATCH --ntasks=8
#SBATCH --mem-per-cpu=32G 
#SBATCH --time=10-0:0:0

module load StdEnv OBITools/1.2.12-foss-2018b-Python-2.7.15

ngsfilter -t mapping_file.txt -u unidentified_seq.fasta -e 2 merged.fastq.assembled.fastq > merged_demultiplexed.fastq

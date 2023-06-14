#!/bin/bash

#SBATCH --account=nn9813k
#SBATCH --job-name=pear
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem-per-cpu=8G 
#SBATCH --time=72:00:00

screen
module load PEAR/0.9.11-GCCcore-9.3.0

pear -f 2-PL02-Leray_S2_R1_001.fastq.gz -r 2-PL02-Leray_S2_R2_001.fastq.gz -o merged.fastq

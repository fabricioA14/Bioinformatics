#!/bin/bash

#SBATCH --account=nn9813k
#SBATCH --job-name=pear
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem-per-cpu=8G 
#SBATCH --time=72:00:00

module load StdEnv OBITools/1.2.12-foss-2018b-Python-2.7.15

obigrep -L 330 merged_demultiplexed.fastq > merged_assigned_L330.fastq

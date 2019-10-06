#!/bin/bash

#SBATCH -p normal
#SBATCH -t 48:00:00
#SBATCH -N 3
#SBATCH -n 12
#SBATCH -A fMRI-Fear-Conditioni
#SBATCH -J fmriprep
#SBATCH --mail-user=achennings@utexas.edu
#SBATCH --mail-type=all

fmriprep_job.txt

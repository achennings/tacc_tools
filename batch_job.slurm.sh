#SBATCH -p normal
#SBATCH -t 12:00:00
#SBATCH -N 1
#SBATCH -n 24
#SBATCH -A fMRI-Fear-Conditioni
#SBATCH -J fmriprep
#SBATCH --mail-user=achennings@utexas.edu
#SBATCH --mail-type=all

fmriprep_job.txt
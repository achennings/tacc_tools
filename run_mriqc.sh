#!/bin/bash

#this is the paragraph that takes in the -s subject arg
group_level=false

while getopts s:g opt; do
    case $opt in
     s)
        echo "running MRIqc on subject ${OPTARG}"
	SUBJ=$OPTARG
        ;;
     g)
        echo "running group level MRIqc"
	group_level=true
     esac
done	 

# Set up inputs, parameters, and outputs
image="$SCRATCH/bids-apps/mriqc.0.15.1.simg"

# It is on you to make sure that these folders exist before running
dataset_name="ft-bids"

in="$SCRATCH/$dataset_name"

#point too and make output dir
out="${SCRATCH}/${dataset_name}/derivatives/mriqc"
mkdir -p ${out}

#point to and make fmriprep working dir
qc_work="$SCRATCH/mriqc"
mkdir -p ${qc_work}

# make output directory
mkdir -p ${out}

# move into work directory
cd ${qc_work}

# load singularity
module load tacc-singularity

#Handle the group level command
if $group_level
then
  singularity run --cleanenv ${image} ${in} ${out} group \
      --modalities T1w bold \
      --n_procs 12 --mem_gb 64 \
      -w ${qc_work} \
      --no-sub \
      --float32 \
      --hmc-fsl
else
#Run mriqc
  singularity run --cleanenv ${image} ${in} ${out} participant \
      --participant_label ${SUBJ} \
      --modalities T1w bold \
      --n_procs 12 --mem_gb 64 \
      -w ${qc_work} \
      --no-sub \
      --float32 \
      --hmc-fsl
fi

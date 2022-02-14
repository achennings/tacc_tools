#!/bin/bash

#thiss is the paragraph that takes in the -s subject arg
group_level=false

while getopts ":d:s:g" opt; do
    case ${opt} in
      d)
        echo "bids dataset ${OPTARG}"
        DATASET=$OPTARG
        ;;
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
image="$SCRATCH/bids-apps/mriqc.sif"

# It is on you to make sure that these folders exist before running
dataset_name="${DATASET}-bids"

in="$SCRATCH/$dataset_name"

#point too and make output dir
out="${SCRATCH}/qc/${DATASET}"
mkdir -p ${out}

qc_work="$SCRATCH/tmp_qc/${SUBJ}"
mkdir -p ${qc_work}
# move into work directory
cd ${qc_work}

#Handle the group level command
if $group_level
then
  singularity run -e ${image} ${in} ${out} group \
      --modalities bold \
      --work-dir ${qc_work} \
      --n_procs 56 --mem_gb 192
else
#Run mriqc
  singularity run -e ${image} ${in} ${out} participant \
      --participant-label ${SUBJ} \
      --modalities bold \
      --work-dir ${qc_work} \
      --n_procs 8 --mem_gb 24
fi

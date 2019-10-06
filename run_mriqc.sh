#!/bin/bash
# Set up inputs, parameters, and outputs
image="$WORK/bids-apps/mriqc.0.15.0.simg"

# It is on you to make sure that these folders exist before running
dataset_name="CCX-bids"

in="$WORK/$dataset_name"

#point too and make output dir
out="$WORK/$dataset_name/derivatives"
mkdir -p ${out}

#point to and make fmriprep working dir
qc_work="$WORK/mriqc"
mkdir -p ${qc_work}

# make output directory
mkdir -p ${out}

# move into work directory
cd ${qc_work}

# load singularity
module load tacc-singularity

# Run fmriprep
singularity run --cleanenv ${image} ${in} ${out} participant \
    --participant_label ${SUBJ} \
    --modalities T1w T2w bold \
    --n_procs 24 --mem_gb 64 \
    -w ${qc_work} \
    --no-sub \
    --float32 \
    --hmc-fsl \

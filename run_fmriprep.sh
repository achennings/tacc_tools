#!/bin/bash

while getopts :s: opt; do
    case $opt in
     s)
        SUBJ=$OPTARG
        ;;
    esac
done

# Set up inputs, parameters, and outputs
image="$SCRATCH/bids-apps/fmriprep.1.5.4.simg"

# It is on you to make sure that these folders exist before running
dataset_name="fc-bids"

in="$SCRATCH/$dataset_name"

#point too and make output dir
out="$SCRATCH/$dataset_name/derivatives"
mkdir -p ${out}

#point to and make fmripre working dir
prep_work="$SCRATCH/fmriprep"
mkdir -p ${prep_work}

#point to Freesurfer licesnse file (thanks Harvard) 
#could not get this variable to work, defined in-line at the moment
#fslicense_file=$WORK/bids-apps/freesurfer_lincense.txt

# make output directory
mkdir -p ${out}

# move into work directory
cd $SCRATCH/fmriprep

# load singularity
module load tacc-singularity

# Run fmriprep
singularity run --cleanenv ${image} ${in} ${out} participant \
    --participant_label ${SUBJ} \
    --output-spaces MNI152NLin2009cAsym T1w fsnative \
    --nthreads 12 --mem_mb 64000 \
    -w ${prep_work} \
    --fs-license-file $WORK/bids-apps/freesurfer_license.txt

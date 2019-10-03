# create the fmriprep and MRIqc singularity images on TACC allocation
# puts it in a folder called "fmriprep" in your $WORK directory

module load tacc-singularity

FMRIPREP_VERS=1.4.0

DEST=${WORK}/fmriprep.${FMRIPREP_VERS}.simg

mkdir ${DEST}

singularity build \
    ${DEST} \
    docker://poldracklab/fmriprep:${FMRIPREP_VERS}
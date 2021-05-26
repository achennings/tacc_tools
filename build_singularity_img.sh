# create the fmriprep and MRIqc singularity images on TACC allocation
# puts the images in a folder in $WORK called bids-apps

DEST=${SCRATCH}/bids-apps
mkdir -p ${DEST}

FMRIPREP_VERS=20.2.1
MRIQC_VERS=0.16.1
#for all intents and purposes this should work but something is wrong with my python version and doesn't run for me, try it anyways...

SINGULARITY_NOHTTPS=yes 

echo DOING NOTHING, UNCOMMENT WHICH IMAGES TO BUILD IN THE FILE
#singularity build \
#    ${DEST}/fmriprep.simg \
#    docker://nipreps/fmriprep:${FMRIPREP_VERS}

#singularity build \
#    ${DEST}/mriqc.simg \
#    docker://poldracklab/mriqc:${MRIQC_VERS}

#singularity build \
#    ${DEST}/neurodocker.simg \
#    docker://achennings/neurodocker:latest

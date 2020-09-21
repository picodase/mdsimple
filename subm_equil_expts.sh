#!/bin/bash

# ******************<RUN SIMULATIONS>********************

# RUN SIMULATIONS

# for each folder,

for D in *; do
    if [ -d "${D}" ]; then
        cd "${D}"
        #echo "${D}"  # echo the directory name
        qsub qsub_emin_nvt_npt_equil.sh     # run qsub on the qsub script for preparation
        cd ..
    fi
done
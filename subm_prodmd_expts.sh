#!/bin/bash

# ******************<RUN SIMULATIONS>********************

# RUN SIMULATIONS

# for each folder,

for D in expts/*; do
    if [ -d "${D}" ]; then
        cd "${D}"
        #echo "${D}"   # your processing here
        qsub qsub_prodmd.sh     # run qsub on the qsub script for preparation
        sleep 5
        cd ..
    fi
done

#!/bin/bash

# ******************<DECLARE VARIABLES AND CONSTANTS>********************

# take in arrays or values of variables!
SIM_MODL=$1     # names of pdb-type models in PWD/modl verified pre-simulation
SIM_REPS=$2     # number of replicates to run each simulation for
SIM_SOLV=$3     # names of solvents in PWD/solv verified pre-simulation
SIM_FFLD=$4     # names of force fields in PWD/ffld (?) verified pre-simulation
SIM_LIGS=$5     # names of ligands (can be array of arrays!) in PWD/ligs verified pre-simulation

# ******************</DECLARE VARIABLES AND CONSTANTS>*******************

# make dir to store expt datafiles
mkdir expts 
cd expts

# make experiment directories
mkdir ./{Acetone,Cyp,Fab}_1_{298,490}_{Vac,HHO,AON}

# create/write specialized mdp files to the appropriate directory (IN PROGRESS)

# copy standard md files into each directory
parallel cp -r standard/ solv_boxes/ solv_topols/ ::: ./{Acetone,Cyp,Fab}_1_{298,490}_{Vac,HHO,AON}

#


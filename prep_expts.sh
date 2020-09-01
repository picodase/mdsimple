#!/bin/bash

# ******************<DECLARE VARIABLES AND CONSTANTS>********************

# take in arrays or values of variables!
#SIM_MODL=$1     # names of pdb-type models in PWD/modl verified pre-simulation
#SIM_REPS=$2     # number of replicates to run each simulation for
#SIM_SOLV=$3     # names of solvents in PWD/solv verified pre-simulation
#SIM_FFLD=$4     # names of force fields in PWD/ffld (?) verified pre-simulation
#SIM_LIGS=$5     # names of ligands (can be array of arrays!) in PWD/ligs verified pre-simulation

# ******************</DECLARE VARIABLES AND CONSTANTS>*******************

# specify all variables beforehand
sim_modl=(Acetone CypA FAB)     # names of pdb-type models in PWD/modl verified pre-simulation
sim_reps=(1)     # number of replicates to run each simulation for
sim_tmps=(298 310)
sim_solv=(SPC AON)     # names of solvents in PWD/solv verified pre-simulation
sim_ffld=(G54a7)     # names of force fields in PWD/ffld (?) verified pre-simulation
#sim_ligs=(None)     # names of ligands (can be array of arrays!) in PWD/ligs verified pre-simulation

# ******************<PREPARE EXPT FOLDERS>********************

# make dir to store expt datafiles
mkdir expts 
cd expts

# make experiment directories

for (( i = 0; i <= ${#sim_modl[@]}-1; i++ ))
do
    for (( j = 0 ; j <= ${#sim_reps[@]}-1; j++ ))
    do
        for (( k = 0 ; k <= ${#sim_tmps[@]}-1; k++ ))
        do
            for (( l = 0 ; l <= ${#sim_solv[@]}-1; l++ ))
            do
                for (( m = 0 ; m <= ${#sim_ffld[@]}-1; m++ ))
                do
                    mkdir ${sim_modl[i]}_${sim_reps[j]}_${sim_tmps[k]}_${sim_solv[l]}_${sim_ffld[m]}
                    #echo -n "$i "
                    # copy standard folder of mdps over to cwd
                    #cp ../../standard .
                    
                    # use sed to replace sim params with desired parameters
                    ## Ensure you make the files dynamically indexable; do NOT write w.r.t. specific line numbers, use a special token, e.g. [EXPTEMP]

                    # run all pre-processing steps
                    #bash gmd_setup.sh

                done
            done
        done
    done
done

# ******************</PREPARE EXPT FOLDERS>*******************
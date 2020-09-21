#!/bin/bash

# ******************<DECLARE VARIABLES AND CONSTANTS>********************

# take in arrays or values of variables!
#SIM_MODL=$1     # names of pdb-type models in PWD/modl verified pre-simulation
#SIM_REPS=$2     # number of replicates to run each simulation for
#SIM_SOLV=$3     # names of solvents in PWD/solv verified pre-simulation
#SIM_FFLD=$4     # names of force fields in PWD/ffld (?) verified pre-simulation
#SIM_LIGS=$5     # names of ligands (can be array of arrays!) in PWD/ligs verified pre-simulation

# ******************</DECLARE VARIABLES AND CONSTANTS>*******************

# filepaths
mdl_fp="/home/jacobnorth/Documents/GitHub/mdsimple/models/"
mdp_fp="/home/jacobnorth/Documents/GitHub/mdsimple/standard/"
md_ff="/home/jacobnorth/Documents/GitHub/mdsimple/gromos54a7_atb.ff/"
md_base="/home/jacobnorth/Documents/GitHub/mdsimple/md_scripts/base_md/"
md_simsrc="/home/jacobnorth/Documents/GitHub/mdsimple/sim_src/"

# specify all variables beforehand
sim_modl=(5kv7 3okh)
#sim_modl=(acetone cyp fab)     # names of pdb-type models in PWD/modl verified pre-simulation
#sim_modl=(acetone)     # names of pdb-type models in PWD/modl verified pre-simulation
sim_reps=(1 2)     # number of replicates to run each simulation for
sim_tmps=(298 310)
#sim_tmps=(298)
#sim_solv=(SPC AON)     # names of solvents in PWD/solv verified pre-simulation
sim_solv=(SPC)     # names of solvents in PWD/solv verified pre-simulation
sim_ffld=(G54a7)     # names of force fields in PWD/ffld (?) verified pre-simulation
sim_stps=(5000000)     # length of time
#sim_ligs=(None)     # names of ligands (can be array of arrays!) in PWD/ligs verified pre-simulation

# selection variables for mdp files
spec_pref=("drugdes_protein_dynamics")
#solv_itc=("4.5e-5" "1.25e-2")
solv_itc=("4.5e-5")
#solv_file=("spc216.gro" "gromos54a7_atb.ff/aon_box_g.gro")
solv_file=("spc216.gro")
sys_prot="Protein"
sys_solv="Non-Protein"

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
                    for (( n = 0 ; n <= ${#sim_stps[@]}-1; n++ ))
                    do
                        sim_name="${sim_modl[i]}_${sim_reps[j]}_${sim_tmps[k]}_${sim_solv[l]}_${sim_ffld[m]}_${sim_stps[n]}"
                        
                        mkdir ${sim_name}

                        # enter the new folder
                        cd ${sim_name}

                        # copy standard data to cwd

                        ##### UNCOMMENT THE FOLLOWING LINE IF YOU'RE JUST USING A SINGLE PROTEIN TYPE!!!#####
                        #cp ${md_simsrc}* .  # topology, box coord, posre files       # currently for a single protein type!
                        cp ${md_base}* .            # copy everything in md_base to cwd
                        cp -r ${mdp_fp} .                  # copy standard folder of mdps
                        cp ${mdl_fp}*${sim_modl[i]}.pdb .   # copy proper model
                        cp -r ../../*.ff/ .                 # copy ff dirs

                        # use sed to replace sim params with desired parameters
                        ## Ensure you make the files dynamically indexable; do NOT write w.r.t. specific line numbers, use a special token, e.g. [EXPTEMP]

                        # in em.mdp, 
                        sed -i "s/SIM_TITLE/${sim_name}/g" standard/em.mdp

                        # in nvt.mdp,
                        sed -i "s/SIM_TITLE/${sim_name}/g" standard/nvt.mdp                        
                        sed -i "s/T_REF/${sim_tmps[k]}/g" standard/nvt.mdp    # replace T_ref with sim_tmps[k]
                        sed -i "s/PROT/${sys_prot}/g" standard/nvt.mdp   # replace [PROT] with sys_prot
                        sed -i "s/SOLV/${sys_solv}/g" standard/nvt.mdp   # replace [SOLV] with sys_solv

                        # in npt.mdp, replace
                        sed -i "s/SIM_TITLE/${sim_name}/g" standard/npt.mdp
                        sed -i "s/PROT/${sys_prot}/g" standard/npt.mdp   # replace [PROT] with sys_prot
                        sed -i "s/SOLV/${sys_solv}/g" standard/npt.mdp   # replace [SOLV] with sys_solv
                        sed -i "s/SOL_ITC/${solv_itc[l]}/g" standard/npt.mdp    # replace [SOL_ITC] with solv_itc[l]
                        sed -i "s/T_REF/${sim_tmps[k]}/g" standard/npt.mdp    # replace T_ref with sim_tmps[k]

                        # in md.mdp, 
                        sed -i "s/SIM_TITLE/${sim_name}/g" standard/md.mdp                        
                        sed -i "s/N_STEPS/${sim_stps}/g" standard/md.mdp  # replace [N_STEPS] with 5000000 for 10ns sim
                        sed -i "s/T_REF/${sim_tmps[k]}/g" standard/md.mdp    # replace T_ref with sim_tmps[k]
                        sed -i "s/SOL_ITC/${solv_itc[l]}/g" standard/md.mdp   # replace [SOL_ITC] with solv_itc[l]
                        sed -i "s/PROT/${sys_prot}/g" standard/md.mdp   # replace [PROT] with sys_prot
                        sed -i "s/SOLV/${sys_solv}/g" standard/md.mdp   # replace [SOLV] with sys_solv

                        # run all pre-processing steps

                        #name=${spec_pref}_${sim_modl[i]}        # shorthand for filenames
                        name=${sim_modl[i]}        # shorthand for filenames

                        ##### UNCOMMENT THE FOLLOWING LINES IF YOU'RE JUST USING A SINGLE PROTEIN TYPE!!!#####

                        ##~~~~~~~~~~~~~~~~~~~~~~~~##
                        # if the models have not been generated yet, you can create them here with this (best for only canonically supported structures by the ff):

                        cp ${name}.pdb ${name}_clean.pdb        # alias, it's being weird now

                        gmx pdb2gmx -f ${name}_clean.pdb -o ${name}_processed.gro       # convert to gmx
                        gmx editconf -f ${name}_processed.gro -o ${name}_newbox.gro -c -d 1.0 -bt cubic # put in a box
                        ##~~~~~~~~~~~~~~~~~~~~~~~~##

                        #gmx solvate -cp ${spec_pref}_newbox.gro -cs ${solv_file[l]} -o ${name}_solv.gro -p topol.top
                        gmx solvate -cp ${name}_newbox.gro -cs ${solv_file[l]} -o ${name}_solv.gro -p topol.top

                        gmx grompp -f standard/ions.mdp -c ${name}_solv.gro -p topol.top -o ions.tpr -maxwarn 1    # Generate the restraint file
                        gmx genion -s ions.tpr -o ${name}_solv_ions.gro -p topol.top -pname NA -nname CL -neutral   # Generate ions inside the box
                        gmx grompp -f standard/em.mdp -c ${name}_solv_ions.gro -p topol.top -o em.tpr -maxwarn 2    # Assemble the binary input

                        cd ..           # exit the folder
                    done
                done
            done
        done
    done
done

# ******************</PREPARE EXPT FOLDERS>*******************
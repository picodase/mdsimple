#!/bin/bash

Help()
{
	# Display Help
	echo "prep_large_simulation_set.sh"
	echo
	echo "Syntax:	bash prep_large_simulation_set.sh [-g|h|v|V]"
	echo "options:"
	echo "	g	Print the GPL license notification.		(NOT IMPLEMENTED)"
	echo "	h	Print this Help."
	echo "	i	Interactive structure parsing mode.		(NOT IMPLEMENTED)"
	echo "	a	Automated structure parsing mode.		(NOT IMPLEMENTED)"
	echo "	v	Verbose mode.					(NOT IMPLEMENTED)"
	echo "	V	Print software version and exit.		(NOT IMPLEMENTED)"
	echo
}

if [ "$1" = "-h" ] ; then
	Help
	exit 0
fi

# Interactive mode
if [ "$1" = "-i" ]; then
	set -e	# If anything fails, exit!
fi

# Automated parsing mode
if [ "$1" = "-a" ]; then
	automated=true# If something fails,
	failed=()	# Append the current structure to the list of failed structures
fi

set -e	# If anything fails, exit!

# ******************<DECLARE VARIABLES AND CONSTANTS>********************

# take in arrays or values of variables!
#SIM_MODL=$1     # names of pdb-type models in PWD/modl verified pre-simulation
#SIM_REPS=$2     # number of replicates to run each simulation for
#SIM_SOLV=$3     # names of solvents in PWD/solv verified pre-simulation
#SIM_FFLD=$4     # names of force fields in PWD/ffld (?) verified pre-simulation
#SIM_LIGS=$5     # names of ligands (can be array of arrays!) in PWD/ligs verified pre-simulation

# ******************</DECLARE VARIABLES AND CONSTANTS>*******************

# CLUSTER FILEPATH
dataset_fp="/home/other/northj/datasets/refined-set/"
mdl_fp="/home/other/northj/GitHub/mdsimple/models/"
mdp_fp="/home/other/northj/GitHub/mdsimple/standard/"
md_ff="/home/other/northj/GitHub/mdsimple/gromos54a7_atb.ff/"
md_base="/home/other/northj/GitHub/mdsimple/md_scripts/base_md/"
md_simsrc="/home/other/northj/GitHub/mdsimple/sim_src/"

# HOME PC FILEPATH
#mdl_fp="/home/jnorth/Documents/GitHub/mdsimple/models/"
#mdp_fp="/home/jnorth/Documents/GitHub/mdsimple/standard/"
#md_ff="/home/jnorth/Documents/GitHub/mdsimple/gromos54a7_atb.ff/"
#md_base="/home/jnorth/Documents/GitHub/mdsimple/md_scripts/base_md/"
#md_simsrc="/home/jnorth/Documents/GitHub/mdsimple/sim_src/"

# specify all variables beforehand

# Removed 1CTU 1SL3 5BRY 3O9I 4DFG 3P3G 1Z6E 5SZ7 4CD0 2VH6 4QGD 1T32 4J21 
# Working: 3SM2 2BAK 5NK3 + others

sim_modl=( $( cat input.strucs ) )

#sim_modl=()

# Convert all strings in the sim_modl array to uppercase

# If the models directory doesn't exist,
if [ ! -d ./models ]; then
	mkdir -p models;
fi

# * Retrieve files from the PDBBind folder:

for e in ${sim_modl[@]}	# For each string in the sim_modl array,
do
	FILE=${dataset_fp}${e,,}/${e,,}_protein.pdb
	if [ -f "$FILE" ]; then
		echo -e "Copying\t ${FILE}\t..."
		# If the directory contains the current model name suffixed with _protein.pdb,
		cp ${FILE} ${mdl_fp}${e}.pdb	# Copy this ${PDB_ID}_protein.pdb file to the "models" filepath as ${PDB_ID}.pdb
	fi
done

# Take in all variables required for simulation setup
source sim_vars.sh

#sim_modl=(acetone cyp fab)     # names of pdb-type models in PWD/modl verified pre-simulation
#sim_modl=(acetone)     # names of pdb-type models in PWD/modl verified pre-simulation
#sim_reps=(1)     # number of replicates to run each simulation for
#sim_tmps=(298 310)
#sim_tmps=(310)
#sim_solv=(SPC AON)     # names of solvents in PWD/solv verified pre-simulation
#sim_solv=(SPC)     # names of solvents in PWD/solv verified pre-simulation
#sim_ffld=(G54a7)     # names of force fields in PWD/ffld (?) verified pre-simulation
#sim_stps=(250000000)     # length of time
#sim_ligs=(None)     # names of ligands (can be array of arrays!) in PWD/ligs verified pre-simulation

# selection variables for mdp files
#spec_pref=("drugdes_protein_dynamics")
#solv_itc=("4.5e-5" "1.25e-2")
#solv_itc=("4.5e-5")
#solv_file=("spc216.gro" "gromos54a7_atb.ff/aon_box_g.gro")
#solv_file=("spc216.gro")
#sys_prot="Protein"
#sys_solv="Non-Protein"

# ******************<PREPARE EXPT FOLDERS>********************

# make dir to store expt datafiles
if [ ! -d ./expts ]; then
	mkdir expts;
fi

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

			# If the simulation hasn't already been run yet, set it up
			if [ ! -d ./${sim_name} ]; then

	                        mkdir -p ${sim_name}

        	                # enter the new folder
           	             	cd ${sim_name}
	
        	                # copy standard data to cwd

                	        ##### UNCOMMENT THE FOLLOWING LINE IF YOU'RE JUST USING A SINGLE PROTEIN TYPE!!!#####
                        	#cp ${md_simsrc}* .  # topology, box coord, posre files       # currently for a single protein type!
	                        cp ${md_base}* .            # copy everything in md_base to cwd
        	                cp -r ${mdp_fp} .                  # copy standard folder of mdps
                	        #cp ${mdl_fp}*${sim_modl[i]}.pdb .   # copy proper model
                        	cp ${mdl_fp}${sim_modl[i]}.pdb .   # copy proper model
	                        #cp -r ../../*.ff/ .                 # copy ff dirs

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

				# Select one of the following
				grep -v HOH ${name}.pdb > ${name}_clean.pdb	# WARNING! NOT REASONABLE FOR TIGHLY BOUND WATERS!!!
                	        #cp ${name}.pdb ${name}_clean.pdb        # alias, it's being weird now

                        	gmx pdb2gmx -f ${name}_clean.pdb -o ${name}_processed.gro -ignh      # convert to gmx
				pdb2gmxstatus=$?	# Get the status of the structure, to tell whether it failed
				# Check the status!
				if [[ ! pdb2gmxstatus = 0 ]] && [[ automated ]] ; then	# If pdb2gmx failed and the parsing mode is set to "automated", then
					failed+=${name}	# Append this structure's ID to the "failed" array
					echo "${name}" >> failed.strucs	# Append this ID to the failed.strucs file
					break	# Leave this structure, but continue execution on the remaining items
				fi

	                        gmx editconf -f ${name}_processed.gro -o ${name}_newbox.gro -c -d 1.0 -bt cubic # put in a box
        	                ##~~~~~~~~~~~~~~~~~~~~~~~~##

                	        #gmx solvate -cp ${spec_pref}_newbox.gro -cs ${solv_file[l]} -o ${name}_solv.gro -p topol.top
                	        gmx solvate -cp ${name}_newbox.gro -cs ${solv_file[l]} -p topol.top -o ${name}_solv.gro

                        	gmx grompp -f standard/ions.mdp -c ${name}_solv.gro -p topol.top -o ions.tpr -maxwarn 1    # Generate the restraint file
	                        gmx genion -s ions.tpr -o ${name}_solv_ions.gro -p topol.top -pname NA -nname CL -neutral   # Generate ions inside the box
        	                gmx grompp -f standard/em.mdp -c ${name}_solv_ions.gro -p topol.top -o em.tpr -maxwarn 2    # Assemble the binary input
                	        cd ..           # exit the folder
			fi 
                    done
                done
            done
        done
    done
done

# ******************</PREPARE EXPT FOLDERS>*******************

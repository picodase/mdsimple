#!/bin/bash

#This script needs to be edited for each run.

#%%%%%%%%%%%%%%%%%%%%<CONFIGURATION>%%%%%%%%%%%%%%%%%%%#

JLN_SIM_TIMESTAMP=$(date +"%Y_%m_%d_%H_%M_%S")  # Define the timestamp for the new simulation, to identify the simulation folder and files
JLN_SIM_TYPE='mdsim'    # Define the simulation type (prefix)
JLN_SIM_PDBNAME=$1			# Take in first cmdlnarg as the PDB filename to query
#JLN_DATAPATH=/Users/jacobnorth/Box/extracurriculars/research/SURE_S2020_fileshare/sure_data		# Datafile path
#JLN_SIM_PATH=$JLN_DATAPATH/$JLN_SIM_PDBNAME/"${JLN_SIM_TYPE}_${JLN_SIM_TIMESTAMP}"		# Simulation-specific datafile path
JLN_SIM_PATH=$JLN_SIM_PDBNAME/"${JLN_SIM_TYPE}_${JLN_SIM_TIMESTAMP}"		# Simulation-specific datafile path
#JLN_ANAPATH=$JLN_SIM_PATH/analysis		# Analysis filepath
mkdir -p ${PWD}/${JLN_SIM_PATH}  # Make a directory for the current simulation (ANAPATH creates all three target directories)
echo "Simulation filepath is:"
echo ${JLN_SIM_PATH}

#%%%%%%%%%%%%%%%%%%%</CONFIGURATION>%%%%%%%%%%%%%%%%%%%#

#%%%%%%%%%%%%%%%%%%%<GROMACS CONFIG>%%%%%%%%%%%%%%%%%%%#

# Gromacs parameters
GROMACS_PDB=$1				# Take in first cmdlnarg
PDB_REMOVE="HOH"
GROMACS_FORCEFIELD="gromos53a6"		# Define ff name
GROMACS_WATERMODEL="spc"			# Define water model name
#GROMACS_BOXTYPE="dodecahedron"		# Def boxtype
GROMACS_BOXTYPE="cubic"
GROMACS_BOXORIENTATION="1.5"		# Def box orientation
GROMACS_BOXSIZE="5.0"				# Def boxsize
GROMACS_BOXCENTER="2.5"				# Def boxcenter

# Setup GROMACS Job. Probably not necessary to edit past this point.
if [ -z "$JLN_SIM_PATH/$GROMACS_PDB" ]; then
	echo "USAGE: ./setup_GROMACS_job.sh pdb_filename"
	echo "Do NOT include the .pdb extension in the file name."
	exit
fi

#%%%%%%%%%%%%%%%%%%%</GROMACS CONFIG>%%%%%%%%%%%%%%%%%%#

# Then, just call all those scripts in order :)

# CLEANUP 
bash gmd_cleanup.sh			# Clean up previous residual files

# SIMULATION SETUP
# Download the file from RCSB to the datapath directory
for id in ${GROMACS_PDB}
do
  wget https://files.rcsb.org/download/${id}.pdb
done

# Clean the file by removing water molecules
#grep -v $PDB_REMOVE ${GROMACS_PDB}.pdb > ${GROMACS_PDB}_clean.pdb
#echo "File cleaned of unwanted res by grep"
############################################<LOAD MODULES>############################################

# Load a module, if needed
module unload gcc/5.1.0		# remove earlier gcc
module load gcc/9.2.0		# load new gcc
module load gromacs/2019-4	# load GMX

############################################</LOAD MODULES>###########################################

############################################<RUN COMMANDS>############################################

# Convert the file to a .gro file with pdb2gmx
#pdb2gmx -f ${GROMACS_PDB}_clean.pdb -o ${GROMACS_PDB}_processed.gro -water ${GROMACS_WATERMODEL}	# Process the file after removing water
gmx pdb2gmx -f ${GROMACS_PDB}.pdb -o ${GROMACS_PDB}_processed.gro -water ${GROMACS_WATERMODEL}		# Process file with crystal waters

# Edit the box by changing its dimensions
gmx editconf -f ${GROMACS_PDB}_processed.gro -o ${GROMACS_PDB}_newbox.gro -c -d 1.0 -bt cubic

# Solvate the box
gmx solvate -cp ${GROMACS_PDB}_newbox.gro -cs spc216.gro -o ${GROMACS_PDB}_solv.gro -p topol.top

# Rename temp.top*****
# mv temp.top* temp.top

# Download the requisite .mdp parameter file
wget http://www.mdtutorials.com/gmx/lysozyme/Files/ions.mdp

# Generate the restraint file
gmx grompp -f ions.mdp -c ${GROMACS_PDB}_solv.gro -p topol.top -o ions.tpr

# Generate ions inside the box
gmx genion -s ions.tpr -o ${GROMACS_PDB}_solv_ions.gro -p topol.top -pname NA -nname CL -neutral

# Download an input parameter file
wget http://www.mdtutorials.com/gmx/lysozyme/Files/minim.mdp

# Assemble the binary input 
gmx grompp -f minim.mdp -c ${GROMACS_PDB}_solv_ions.gro -p topol.top -o em.tpr

#bash gmd_emin.sh				# Minimize the energy of the system
#bash gmd_nvtequilib.sh			# Equilibrate wrt NVT
#bash gmd_nptequilib.sh			# Equilibrate wrt NPT

# PRODUCTION MD
#bash gmd_prodmd.sh				# Run production MD
#bash gmd_postpmd_analysis.sh	# Analyze post production MD

# RELOCATE FILES TO THE TIMESTAMPED DIRECTORY
#bash gmd_relocate_sim_files.sh	# Relocate files

############################################</RUN COMMANDS>###########################################

############################################<UNLOAD MODULES>##########################################

module unload gromacs/2019-4	# unload GMX
module unload gcc/9.2.0		# unload new gcc, 
module load gcc/5.1.0		# reload old gcc

############################################</UNLOAD MODULES>#########################################
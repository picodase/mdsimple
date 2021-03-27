#!/bin/sh

# Give the job a name
#$ -N emin_nvt_npt_equilibration

# set the shell
#$ -S /bin/sh

# set working directory on all host to
# directory where the job was started
#$ -cwd

# send all process STDOUT (fd 2) to this file
#$ -o job_output.txt

# send all process STDERR (fd 3) to this file
#$ -e job_output.err

# email information
#$ -m e
 
# Just change the email address. You will be emailed when the job has finished.
#$ -M northj@oregonstate.edu

# generic parallel environment with 2 cores requested
#$ -pe orte 2

############################################<LOAD MODULES>############################################

# Load a module, if needed
#module unload gcc/5.1.0		# remove earlier gcc
#module load gcc/9.2.0		# load new gcc
#module load gromacs/2019-4	# load GMX
module load python/anaconda3-latest	# Load conda 

############################################</LOAD MODULES>###########################################

############################################<RUN COMMANDS>############################################

eval "$(command conda 'shell.bash' 'hook' 2> /dev/null)"

conda activate MD

bash gmd_emin.sh	# Call emin
bash gmd_nvtequilib.sh	# Call nvt equilib
bash gmd_nptequilib.sh	# Call npt equilib

############################################</RUN COMMANDS>###########################################

############################################<UNLOAD MODULES>##########################################

module unload python/anaconda3-latest	# Load conda 
#module unload gromacs/2019-4	# unload GMX
#module unload gcc/9.2.0		# unload new gcc, 
#module load gcc/5.1.0		# reload old gcc

############################################</UNLOAD MODULES>#########################################

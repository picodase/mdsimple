#!/bin/sh

# Give the job a name
#$ -N production_md

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
module unload gcc/5.1.0		# remove earlier gcc
module load gcc/9.2.0		# load new gcc
module load gromacs/2019-4	# load GMX

############################################</LOAD MODULES>###########################################

############################################<RUN COMMANDS>############################################

bash gmd_prodmd.sh		# run production MD

############################################</RUN COMMANDS>###########################################

############################################<UNLOAD MODULES>##########################################

module unload gromacs/2019-4	# unload GMX
module unload gcc/9.2.0		# unload new gcc, 
module load gcc/5.1.0		# reload old gcc

############################################</UNLOAD MODULES>#########################################
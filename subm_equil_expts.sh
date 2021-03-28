#!/bin/sh

# ******************<RUN SIMULATIONS>********************

# RUN SIMULATIONS

# Return 0 if there doesn't exist a .log file in the directory, return 1 if there is one.

# For each experiment in the expts folder,

for D in expts/*; do
	# echo "Testing experiment:\t${D}/"
	# em.trr		
	if [ -d "${D}" ] && [ ! -e ${D}/em.trr ]  ; then	# If the directory exists, AND there does NOT exist the em.trr file signifying either an in-progress or completed energy minimization in that directory,	
	#	if [ -d "${D}" ] && [[ ( ! -e ${D}/em.log ) || ( ! -e ${D}/nvt.log ) || ( ! -e ${D}/npt.log ) ]]  ; then	# If the directory exists, AND there does NOT exist the em, nvt, and npt log files signifying a successful energy minimization in that directory,
		echo -e "${D}/ \t(em.trr) DNE\t>>>\t Submitting equilibration job..."
		cd ${D}		# Enter the directory
		#echo "${D}"  	# Echo the directory name

		sim_name="equil_${PWD##*/}"

		sed -i "s/emin_nvt_npt_equilibration/${sim_name}/g" qsub_emin_nvt_npt_equil.sh	# Use `sed` to add the title (sans "expts") to the qsub script
		
		qsub qsub_emin_nvt_npt_equil.sh	# Run qsub on the qsub script for preparation
		sleep 0.5	# Give a brief wait
		cd ../..	# Exit the directory / back to the starting folder, "mdsimple
	fi
done

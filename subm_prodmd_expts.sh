#!/bin/bash

# ******************<RUN SIMULATIONS>********************

# RUN SIMULATIONS

# for each folder,

for D in expts/*; do
	if [ -d "${D}" ] && [ -e "${D}/npt.gro" ] && [ ! -e "${D}/md_0_1.log" ] ;  then	# If the directory exists, AND it is a successfully NPT-equilibrated system, AND production MD isn't already running, THEN
		echo -e "${D}/ \t(npt.gro) exists\t>>>\t Submitting Production MD job..."
		cd ${D}		# Enter the directory
		#echo "${D}"  	# Echo the directory name

		sim_name="prodMD_${PWD##*/}"

		sed -i "s/production_md/${sim_name}/g" qsub_prodmd.sh

		qsub qsub_prodmd.sh 	# Run qsub on the qsub script for preparation
		sleep 0.5	# Give a brief wait
		cd ../..	# Exit the directory / back to the starting folder, "mdsimple"
	elif [ -e "${D}/md_0_1.log" ] ; then	# Else, if the production MD job is running,
		echo -e "${D}/ \t(md_0_1.log) exists\t>>>\t Production MD job was already run..."
	fi
done

#!/bin/bash

# Download the .mdp for the NVT equilib
wget http://www.mdtutorials.com/gmx/lysozyme/Files/md.mdp

# Pre-process the input files, predict PME load
gmx grompp -f standard/md_1ns.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr

# Run the production MD sim:
gmx mdrun -deffnm md_0_1	
# ON CPU
# mdrun -deffnm md_0_1 -nb gpu	# ON ONE GPU
# ON MULTIPLE GPUS???

# Create plot of pressure, ensure T is stable
#gmx energy -f npt.edr -o pressure.xvg

# Create plot of density
#gmx energy -f npt.edr -o density.xvg
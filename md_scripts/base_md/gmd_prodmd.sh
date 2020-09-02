#!/bin/bash

# Download the .mdp for the NVT equilib
#wget http://www.mdtutorials.com/gmx/lysozyme/Files/md.mdp

# Pre-process the input files, predict PME load
gmx grompp -f standard/md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr -maxwarn 2

# Run the production MD sim:

# ON CPU
gmx mdrun -deffnm md_0_1	

# ON ONE GPU
# mdrun -deffnm md_0_1 -nb gpu	

# ON MULTIPLE GPUS???

# Create plot of pressure, ensure T is stable
#gmx energy -f npt.edr -o pressure.xvg

# Create plot of density
#gmx energy -f npt.edr -o density.xvg
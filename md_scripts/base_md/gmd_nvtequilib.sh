#!/bin/bash

# Download the .mdp for the NVT equilib
wget http://www.mdtutorials.com/gmx/lysozyme/Files/nvt.mdp

# Run an NVT equilibration
gmx grompp -f params/nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr

# Run the NVT equilibration
gmx mdrun -deffnm nvt

# Create plot of temperature, ensure T is stable
#gmx energy -f nvt.edr -o temperature.xvggmx mdrun -deffnm nvt
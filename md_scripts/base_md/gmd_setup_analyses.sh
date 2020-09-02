#!/bin/bash

echo "EMIN POTENTIAL | Select 'potential' at the prompt: "

# Plot energy chart for eminim 
gmx energy -f em.edr -o potential.xvg

echo "NVT EQUILIBRATION TEMPERATURE | Select 'Temperature' at the prompt: "

# Create plot of temperature, ensure T is stable
gmx energy -f nvt.edr -o temperature.xvg

#echo "NPT EQUILIBRATION PRESSURE | Select 'Pressure' at the prompt: "

# Create plot of pressure, ensure T is stable
#gmx energy -f npt.edr -o pressure.xvg

echo "NPT EQUILIBRATION DENSITY | Select 'Density' at the prompt: "

# Create plot of density
#gmx energy -f npt.edr -o density.xvg
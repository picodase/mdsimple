#!/bin/bash

# Invoke the energy minimization
gmx mdrun -v -deffnm em

# Plot energy chart for eminim 
#gmx energy -f em.edr -o potential.xvg
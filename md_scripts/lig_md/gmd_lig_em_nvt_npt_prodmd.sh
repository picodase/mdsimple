#!/bin/bash

LIG_ID=$1

# EMIN

gmx grompp -f params/em.mdp -c ${LIG_ID}_solv_ions.gro -p topol.top -o em.tpr
gmx mdrun -v -deffnm em

# NVT EQUIL
gmx grompp -f params/nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
gmx mdrun -deffnm nvt

# NPT EQUIL
gmx grompp -f params/npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
gmx mdrun -deffnm npt

# PRODMD
gmx grompp -f mdout.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr
gmx mdrun -deffnm md_0_1	# ON CPU
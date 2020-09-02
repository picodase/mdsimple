#!/bin/bash

# Center the trajectory on the protein's center, don't allow periodity weirdness
trjconv -s md_0_1.tpr -f md_0_1.xtc -o md_0_1_ctr_noPBC.xtc -pbc mol -center

# make rotation invariant
gmx trjconv -f md_0_1.xtc -s md_0_1.tpr -o out.xtc -pbc nojump

# reduce rot/trans 
gmx trjconv -f out.xtc -s md_0_1.tpr -o md_0_1_processed.pdb -fit rot+trans

# Calculate RMSD on the corrected trajectory
rms -s md_0_1.tpr -f md_0_1_ctr_noPBC.xtc -o rmsd.xvg -tu ns

# Calc RMSD relative to crystal
rms -s em.tpr -f md_0_1_ctr_noPBC.xtc -o rmsd_xtal.xvg -tu ns

# Calc Radius of gyration
gmx gyrate -s md_0_1.tpr -f md_0_1_ctr_noPBC.xtc -o gyrate.xvg

# GENERAL CONVERSIONS
# Run the command based on need!

# Traj to PDB (select the type of selection wanted)
gmx trjconv -f md_0_1_ctr_noPBC.xtc -s md_0_1.tpr -o md_0_1_trajectory.pdb

# Traj (.xtc) to traj (.xtc) (useful to remove water from the system to compare with a PDB file)
gmx trjconv -f md_0_1_ctr_noPBC.xtc -s md_0_1.tpr -o md_0_1_ctr_noPBC_trajectory.xtc
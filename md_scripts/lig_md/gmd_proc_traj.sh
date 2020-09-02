#!/bin/sh

# PROCESS TRAJ

# minimize RMSD
gmx trjconv -f ${LIG_ID}_md_0_1.trr -s ${LIG_ID}_md_0_1.tpr -o ${LIG_ID}_md_0_1_nojump.xtc -pbc nojump

# reduce rotational effects, normalize
gmx trjconv -f ${LIG_ID}_md_0_1_nojump.xtc -s ${LIG_ID}_md_0_1.tpr -o ${LIG_ID}_md_0_1_normalized.pdb -fit rot+trans
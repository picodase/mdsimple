#!/bin/sh

# DEFINE VARIABLES
NUM_LIG=1
MAX_WARN=1

# CREATE THE SYSTEM

# convert ligand to .gro file
gmx editconf -f ${LIGAND_ID}.pdb -o ${LIGAND_ID}_proc.gro

# add name to topology.top
echo -e "${LIGAND_ID} \t ${NUM_LIG}" >> topol.top  

# define unit cell
gmx editconf -f ${LIGAND_ID}_proc.gro -o ${LIGAND_ID}_in_box.gro -c -d 1.0 -bt dodecahedron

# fill box with water
gmx solvate -cp ${LIGAND_ID}_in_box.gro -cs spc216.gro -p topol.top -o ${LIGAND_ID}_solv.gro

# add ions if necessary
gmx grompp -f ions.mdp -c ${LIGAND_ID}_solv.gro -p topol.top -o ions.tpr
gmx genion -s ions.tpr -o solv_ions.gro -p topol.top -pname NA -nname CL -neutral

# edit mdp files so they use the LIG_ID
# NOT SURE??
sed -i "s/LIG/${LIG_ID}/g" params/em.mdp params/npt_liginsol.mdp params/nvt_liginsol.mdp

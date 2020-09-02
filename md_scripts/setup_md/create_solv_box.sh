#!/bin/sh

# determine the density of the molecule, and thus the box length

# e.g. divide 512 molecules of AON by 40.^3 (box volume), then 
# return 125 A^3 / molecule AON, then
# cubic root of 125 is 5A on a side.
# use 5 angstroms to create an initial small box of AON (single molecule)

gmx editconf -f acetone_molecule.pdb -o acetone_molecule_inbox.gro -c -box 0.5

# use gmx solvate to generate a box of these molecules, 40A on a side

gmx solvate -cs acetone_molecule_inbox.gro -box 4

# OR you can generate a box with packmol, then run editconf

# packmol < input.inp

gmx editconf -f ac_512_packmol.pdb -o ac_512_packmol.gro -box 4

# equilibrate the system at, say, 298K

# create a topology file by hand, ensuring the fields align

# EMIN
gmx grompp -f em_newsolvbox.mdp -c ac_512_packmol.gro -p topol.top -o em.tpr
gmx mdrun -v -deffnm em

# NVT
gmx grompp -f nvt_newsolvbox.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
gmx mdrun -deffnm nvt

# NPT
gmx grompp -f npt_newsolvbox.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
gmx mdrun -deffnm npt
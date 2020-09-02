#!/bin/sh

# ******************</DECLARE VARIABLES AND CONSTANTS>*******************

# filepaths
PDB_PREF=$1
expt_fp="expts/acetone_1_298_AON_G54a7_5000000/"

# ******************<PREPARE EXPT FOLDERS>********************

# Convert the file to a .gro file with pdb2gmx

# ALL CANONICAL RESIDUES
# 1. Obtain coordinate and topology files
#gmx pdb2gmx -f ${GROMACS_PDB}_clean.pdb -o ${GROMACS_PDB}_proc.gro		# Process file with crystal waters

# NONCANONICAL RESIDUES
# 1. Obtain coordinate and topology files from an include topology file (.itp)
#gmx pdb2gmx -f ${expt_fp}${PDB_PREF}.pdb -i gromos54a7_atb.ff/ac_atb.itp -p ${expt_fp}topol.top -o ${expt_fp}${PDB_PREF}_proc.gro 

# cyclic peptides
#gmx pdb2gmx -f ${expt_fp}${PDB_PREF}.pdb -i gromos54a7_atb.ff/ac_atb.itp -p ${expt_fp}topol.top -o ${expt_fp}${PDB_PREF}_proc.gro -ter -missing -ignh

# Edit the box by changing its dimensions
gmx editconf -f ${PDB_PREF}.gro -o ${PDB_PREF}_newbox.gro -c -d 1.0 -bt cubic
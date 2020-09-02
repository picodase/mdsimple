#!/bin/sh

# define variables
PDB_ID=$1       # the first clarg
LIG_ID=$2       # the second clarg

grep ${LIG_ID} ${PDB_ID}.pdb > ${LIG_ID}.pdb    # extract the ligand to a new file

# open the new file in Avogadro, then output with H's (obabel)
obabel ${LIG_ID}.pdb -O ${LIG_ID}_hydrog.pdb -h
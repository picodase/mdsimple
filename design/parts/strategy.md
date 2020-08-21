This will include the following steps:
1. Pre-processing of input files (PDB, topology)
    - Take in a set of starting structures (<filename>.pdb).
    - (optional) Remove water, non-main-chain amino acids, nucleic acids, and ligands if included (non-residues).
    - Generate a topology file for the experiment (currently just GROMACS--pdb2gmx)
    - Check the topology file and edit by hand if necessary, or import a topology.

2. 

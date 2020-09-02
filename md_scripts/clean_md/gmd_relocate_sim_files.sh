#!/bin/bash

# relocate files that AREN'T shell files to the ANA_PATH

mv *.pdb $ANA_PATH		# move .pdb
mv *.gro $ANA_PATH		# move .gro
mv *.itp* $ANA_PATH		# move .itp (inc. backups)
mv *.top* $ANA_PATH		# move .top (inc. backups)
mv *.mdp* $ANA_PATH		# move .mdp (inc. backups)
mv *.tpr $ANA_PATH		# move .tpr
mv *.log $ANA_PATH		# move .log
mv *.edr $ANA_PATH		# move .edr
mv *.cpt $ANA_PATH		# move .cpt

#mv *.trr $ANA_PATH		# move .trr
#mv *.xvg $ANA_PATH		# move .xvg
#mv *.??? $ANA_PATH		# move .???
#!/bin/bash

# remove files that AREN'T shell files

rm *.pdb		# remove .pdb
rm *.gro		# remove .gro
rm *.itp*		# remove .itp (inc. backups)
rm *.top*		# remove .top (inc. backups)
rm *.mdp*		# remove .mdp (inc. backups)
rm *.tpr		# remove .tpr
rm *.log		# remove .log
rm *.edr		# remove .edr
rm *.cpt		# remove .cpt

#rm *.trr		# remove .trr
#rm *.xvg		# remove .xvg
#rm *.???		# remove .???
#!/bin/sh

# selector.sh
# Selects a user-specified number of structures from the PDBBind structure set.

shuf -n $1 INDEX_refined_data.2019 > selected.txt
awk '{print $1}' selected.txt | tr 'a-z' 'A-Z' > input.strucs

#!/bin/sh

# cleaner.sh
# Cleans a user-specified list of structures from the expts directory.

failed_modl=( $( cat failed.strucs ) )

    # rm -rf the folders with that token in them

for e in ${failed_modl[@]}	# For each structure in the list specified by failed.strucs,
do
	if [ -d ./expts/${e}* ]; then
		echo "Removing folder for ID: ${e}"   # Notify the user
        rm -rf ./expts/${e}*   # Remove the folder(s)
    fi
done
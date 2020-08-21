# mdsimple design document

## Understanding the Problem
MD simulations (among other cluster jobs!) are very useful for simulating the motions of molecules and their interactions. However, MD jobs are often created individually and submitted individually--this process is time-costly and takes a long time for an amateur to become useful in creating MD simulations for their target system. This package will be implemented as a UNIX shell script that links the user's inputs, variables, and constants in desired combinations for experimental design. [Read the program steps here](parts/strategy.md)

## Assumptions

## Pros and Cons of this program
- Allows the quick creation of many similar--but tweaked--MD simulations.
- Emphasizes repeatability and consideration of each variable rather than simulating a system with a single set of variables.
- Requires the user to understand the underlying structure and variables used to construct each simulation.

## Pseudocode
View pseudocode [here](parts/pseudocode.md).

## Testing User Input Functions

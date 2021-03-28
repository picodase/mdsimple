sim_reps=(1)     # number of replicates to run each simulation for
#sim_tmps=(298 310)
sim_tmps=(310)
#sim_solv=(SPC AON)     # names of solvents in PWD/solv verified pre-simulation
sim_solv=(SPC)     # names of solvents in PWD/solv verified pre-simulation
sim_ffld=(G54a7)     # names of force fields in PWD/ffld (?) verified pre-simulation
sim_stps=(250000000)     # length of time
#sim_ligs=(None)     # names of ligands (can be array of arrays!) in PWD/ligs verified pre-simulation

# selection variables for mdp files
spec_pref=("drugdes_protein_dynamics")
#solv_itc=("4.5e-5" "1.25e-2")
solv_itc=("4.5e-5")
#solv_file=("spc216.gro" "gromos54a7_atb.ff/aon_box_g.gro")
solv_file=("spc216.gro")
sys_prot="Protein"
sys_solv="Non-Protein"


load gromacs/2021.2

# Generates new inputs
echo -e "2\n1\nq" | gmx pdb2gmx -f pin1.pdb -o pin1.gro -p pin1.top -i pin1.itp -n pin1.ndx -ignh
# 2 (for AMBFER ff14sb) and 1 (for TIP3P)

# Solvates the system
gmx editconf -f pin1.gro -o pin1_box.gro -c -d 3.0 -bt cubic
gmx solvate -cp pin1_box.gro -cs pin1.gro -o pin1_sol.gro -p pin1.top

# Adds ions (makes a tpr using grommp)
gmx grompp -f ion.mdp -c pin1_sol.gro -p pin1.top -o ion.tpr

echo -e "13\nq" | gmx genion -s ion.tpr -o pin1_ions.gro -p pin1.top -pname NA -nname CL -neutral

# Energy minimization (make a tpr using grommp)
gmx grompp -f em.mdp -c pin1_ions.gro -p pin1.top -o em_large_box.tpr

# Submit a job to owlsnest 
qsub em.qsub

# NVT equilibration (make tpr)
gmx grompp -f nvt.mdp -c em.gro -p pin1.top -o nvt.tpr

# Submit a job to owlsnest 
qsub nvt.qsub

# Check if it is truly equilibrated 
echo -e "16\n0\nq" | gmx energy -f nvt.edr -o temperature.xvg
# 16, then 0; if there is a large drift, redo.

# NPT equilibration (make tpr)
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p pin1.top -o npt.tpr

# Submit job to owlsnest 
qsub npt.qsub

# Check if it's equilibrated; remember to select 18 and 0
echo -e "18\n0\nq" | gmx genion -s ion.tpr -o pin1_ions.gro -p pin1.top -pname NA -nname CL -neutral
# Check if there is a large drift; if there is, redo. 

# Production run (make tpr)
gmx grompp -f prod.mdp -c npt.gro -t npt.cpt -p pin1.top -o prod_large_box.tpr
# Check log file 

~  

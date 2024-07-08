################################################
# Here, we will do EM, NVT and NPT interactively


module load gromacs/2021.2
module load mpi/openmpi

# Energy minimization (make a tpr using grommp)
gmx grompp -f em.mdp -c pin1_ions.gro -p pin1.top -o em_large_box.tpr
mpirun mdrun_mpi -v -s em_large_box.tpr -deffnm em


# NVT equilibration (make tpr)
# NOTE: we removes -DPOSRE position restratints from the mdp file
gmx grompp -f nvt.mdp -c em.gro -p pin1.top -o nvt.tpr
mpirun mdrun_mpi -s nvt.tpr -deffnm nvt 


# NPT equilibration (make tpr)
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p pin1.top -o npt.tpr
mpirun mdrun_mpi -s npt.tpr -deffnm npt


# Production run (make tpr)
gmx grompp -f prod.mdp -c npt.gro -t npt.cpt -p pin1.top -o prod_large_box.tpr
# Check log file 

~  

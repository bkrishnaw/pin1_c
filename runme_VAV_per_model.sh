
# load in the pathnames to run gmx 2021.2
module load gromacs/2021.2

# Generates new inputs
# For NOW we will a topology usig AMBER99 and TIP3P
# Also - we KNOW that all 4 HIS residues are HID (delta hydrogen -- with atom name HD1)
echo -e "4\n1\n0\n0\n0\n0\nq" | gmx pdb2gmx -f {MODEL_PDB} -o pin1.gro -p pin1.top -i pin1.itp -n pin1.ndx -his -ignh
# on owlsnest: 4 (for AMBFER ff99b) and 1 (for TIP3P)

# THEN, we need to edit the pin1.top file with the #include 
### ; Include forcefield parameters
### #include "amber99sbnmr1-ildn.ff/forcefield.itp"
# replace the string 'amber96.ff' with the string 'amber99sbnmr1-ildn.ff'
sed -i 's/amber96.ff/amber99sbnmr1-ildn.ff/g' pin1.top


# Solvates the system
gmx editconf -f pin1.gro -o pin1_box.gro -c -d 3.0 -bt cubic
gmx solvate -cp pin1_box.gro -cs spc216.gro -o pin1_sol.gro -p pin1.top
## NOTE: the problem before was that we didn't use "spc216.gro" as the solvent box

# Adds ions (makes a tpr using grommp)
gmx grompp -f ion.mdp -c pin1_sol.gro -p pin1.top -o ion.tpr

# Born et al 2021 says "150 mM sodium chloride buffer at pH 6.5"
echo -e "13\nq" | gmx genion -s ion.tpr -o pin1_ions.gro -p pin1.top -pname NA -nname CL -neutral -conc 0.150
# group 13 is "SOL"


# Energy minimization (make a tpr using grommp)
gmx grompp -f em.mdp -c pin1_ions.gro -p pin1.top -o em_large_box.tpr

~  

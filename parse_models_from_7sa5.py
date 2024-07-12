import os, sys

### NOTE: run this with python3 parse_models_from_7sa5.py 

infile = '7sa5.pdb'
natoms = 2519

fin = open(infile, 'r')
lines = fin.readlines()

model_index = 0
for i in range(len(lines)):
    line = lines[i]

    if line[0:5] == 'MODEL':
        model_index += 1

        model_lines = lines[(i+1):(i+1+natoms)]
        print(line.strip())
        for j in range(natoms-4, natoms):
            print('\t', model_lines[j].strip())


        outfile = f'7sa5_model{model_index}.pdb'
        fout = open(outfile, 'w')
        fout.writelines(model_lines)
        fout.close()


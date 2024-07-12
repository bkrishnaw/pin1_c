import os, sys

### NOTE: This code should be run AFTER parse_models_from_7sa5.py

DEBUG = False

nmodels = 2   # 20
for i in range(1,nmodels+1):

    # make a new dir called 'model{i}'
    outdir = f'model{i}'
    if not os.path.exists(outdir):
        os.mkdir(outdir)

    # copy the model PDB to it
    pdbfile = f'7sa5_model{i}.pdb'
    os.system(f'cp {pdbfile} {outdir}')
   
    # Read in the the runme_VAV_per_model.sh
    #    ... which has a replacable string "{MODEL_PDB}"
    fin = open('runme_VAV_per_model.sh', 'r')
    text = fin.read()
    fin.close()

    # Replace the runme_VAV_per_model.sh string "{MODEL_PDB}" with the model pdb
    keyword = "{MODEL_PDB}"
    text = text.replace(keyword, pdbfile)
    if DEBUG:
        print(text)
        print('\n#################\n')

    # write a new file 'runme.sh' to the new directory
    outfile = os.path.join(outdir, 'runme.sh') 
    fout = open(outfile, 'w')
    fout.write(text)
    fout.close()

    # make this file executable
    os.system(f'chmod +x {outfile}')

    print(f'Wrote: {outfile}')

    # copy all relevant mdp files
    mdp_files = ['em.mdp', 'ion.mdp', 'npt.mdp', 'nvt.mdp']
    for mdp_file in mdp_files:
        os.system(f'cp {mdp_file} {outdir}')

    # copy the AMBER ff99sb-ildn-nmr1 force field
    os.system(f'cp -r amber99sbnmr1-ildn.ff {outdir}')


 




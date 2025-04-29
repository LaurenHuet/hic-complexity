# hic-complexity

**Step 1.** Run the 01_download.sh script, pass in the RUNID and RUNDIR as arguments. 

**example **
bash 01_download.sh "NEXT_250325_AD" "/scratch/pawsey0964/lhuet/download/hic-complex"

**Step 2. ** Stage the assembly files, create a list of OG numbers you are running the complexity anlysis for and call it OG-list.sh. Then run the 02_get_primary_assemblies.sh script. Pass in the download path. 

**example **
bash 02_get_primary_assemblies.sh "/scratch/pawsey0964/lhuet/download/hic-complex"



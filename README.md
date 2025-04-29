# hic-complexity

This page explains how to run the hic-complexity analysis for the high quality reference genomes.

**Step 1.** Run the 01_download.sh script, pass in the RUNID and RUNDIR as arguments. 

**example**
```
bash 01_download.sh "NEXT_250325_AD" "/scratch/pawsey0964/lhuet/download/hic-complex"
```
**Step 2.** Stage the assembly files, create a list of OG numbers you are running the complexity anlysis for and call it OG-list.sh. Then run the 02_get_primary_assemblies.sh script. Pass in the download path. 

**example**
```
bash 02_get_primary_assemblies.sh "/scratch/pawsey0964/lhuet/download/hic-complex"
```
**Step 3.** Put the assemblies into the hic directories, put the get_qc.py, hic-complex.sh and loop.sh into the run directory 
```
**example**

/scratch/pawsey0964/lhuet/download/hic-complex/NEXT_250325_AD/OG37H-1_HICL> rclone tree .
/
├── OG37H-1_HICL_S1_L001_R1_001.fastq.gz
├── OG37H-1_HICL_S1_L001_R2_001.fastq.gz
├── OG37H-1_HICL_ds.5a7614fa2c6543b39686cf1f2131fe34.json
├── OG37_v240116.hifi1.0.hifiasm.p_ctg.fasta

# where the run directory would be
/scratch/pawsey0964/lhuet/download/hic-complex/NEXT_250325_AD/
```
**Step 4.** Update the loop script for your samples and submit the script
```
**example** 
bash 04_loop.sh
```
**Step 5. **

Copy the contents of the OGXX.out.preseq files to the relevant LabArchives HiC library prep entry (which will be listed next to the sample in the asana card). It will look like this:
```
TOTAL_READS        EXPECTED_DISTINCT        LOWER_0.95CI        UPPER_0.95CI
0        0        0        0
100000000.0        74047248.6        72906997.4        74927510.8
200000000.0        117846551.0        115004294.8        120134479.9
300000000.0        146792327.5        142415231.3        150378028.4
400000000.0        167344812.5        161683723.1        172042113.5
500000000.0        182692138.1        175968678.1        188324995.1
600000000.0        194589450.6        186982093.1        201007923.8
700000000.0        204082529.0        195732369.2        211165923.2
800000000.0        211833273.3        202852088.5        219484732.5
900000000.0        218281039.4        208758171.5        226422387.2
1000000000.0        223728916.8        213736564.1        232296487.5
1100000000.0        228392755.8        217989923.8        237334188.8
1200000000.0        232430448.7        221665886.5        241702257.7
1300000000.0        235960158.8        224874552.2        245525889.0
1400000000.0        239072076.7        227699701.7        248900899.7
1500000000.0        241836235.4        230206217.2        251901868.6
1600000000.0        244307843.6        232445126.6        254587711.8
1700000000.0        246531011.1        234457114.4        257005589.3
1800000000.0        248541404.4        236275015.5        259193697.9
1900000000.0        250368174.7        237925621.6        261183304.1
2000000000.0        252035380.6        239431010.3        263000247.7
```

Find and copy the summary stats in the job output file (HICLCA_*.out)- it will look like this, add this to the lab archivives page with the preseq output. 
```
=========================================
SLURM_JOB_ID = 24183002
SLURM_NODELIST = nid001357
DATE: 250429
=========================================
Full path: /scratch/pawsey0964/lhuet/download/hic-complex/NEXT_250325_AD
Run directory: /scratch/pawsey0964/lhuet/download/hic-complex/NEXT_250325_AD
Sample directory: OG37H-1_HICL
Specimen ID: OG37
Hi-C forward: /scratch/pawsey0964/lhuet/download/hic-complex/NEXT_250325_AD/OG37H-1_HICL/OG37H-1_HICL_S1_L001_R1_001.fastq.gz
Hi-C reverse: /scratch/pawsey0964/lhuet/download/hic-complex/NEXT_250325_AD/OG37H-1_HICL/OG37H-1_HICL_S1_L001_R2_001.fastq.gz
assembly: /scratch/pawsey0964/lhuet/download/hic-complex/NEXT_250325_AD/OG37H-1_HICL/OG37_v240116.hifi1.0.hifiasm.p_ctg.fasta
Total Read Pairs                              6,349,191  100%
Unmapped Read Pairs                           140,555    2.21%
Mapped Read Pairs                             5,334,784  84.02%
PCR Dup Read Pairs                            363,105    5.72%
No-Dup Read Pairs                             4,971,679  78.3%
No-Dup Cis Read Pairs                         2,046,782  41.17%
No-Dup Trans Read Pairs                       2,924,897  58.83%
No-Dup Valid Read Pairs (cis >= 1kb + trans)  3,653,132  73.48%
No-Dup Cis Read Pairs < 1kb                   1,318,547  26.52%
No-Dup Cis Read Pairs >= 1kb                  728,235    14.65%
No-Dup Cis Read Pairs >= 10kb                 642,132    12.92%
```

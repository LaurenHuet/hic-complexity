#!/bin/bash


run_dir="/scratch/pawsey0964/lhuet/download/hic-complex/NEXT_250325_AD"
temp="/scratch/pawsey0964/lhuet/download/hic-complex/NEXT_250325_AD"
samples=(
    "OG37H-1_HICL OG37"
    "OG62G-1_HICL OG62"
    "OG664G-1_HICL OG664"
    "OG665L-2_HICL OG665"
    "OG698L-1_HICL OG698"
    "OG749G-2_HICL OG749"
    "OG785G2_HICL OG785"
    "OG803G-1_HICL2 OG803"
    "OG824G-1_HICL OG824" 
    "OG855L-2_HICL OG855"
    "OG866G-3_HICL OG866"
)


for sample in "${samples[@]}"; do
    set -- $sample
    sample_dir=$1
    OG=$2
    sbatch hic-complex.sh "$run_dir" "$sample_dir" "$OG" "$temp"
done
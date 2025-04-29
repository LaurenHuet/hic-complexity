#!/bin/bash --login
#---------------
#Requested resources:
#SBATCH --account=pawsey0964
#SBATCH --job-name=HICLCA
#SBATCH --partition=work
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
#SBATCH --time=02:00:00
#SBATCH --mem=64G
#SBATCH --export=ALL
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err

date=$(date +%y%m%d)

echo "========================================="
echo "SLURM_JOB_ID = $SLURM_JOB_ID"
echo "SLURM_NODELIST = $SLURM_NODELIST"
echo "DATE: $date"
echo "========================================="

full_path=$(pwd)
echo "Full path: $full_path"

run_dir="$1"
echo "Run directory: $run_dir"
sample_dir="$2"
echo "Sample directory: $sample_dir"
OG="$3"
echo "Specimen ID: $OG"
 
# Define path to temp directory
temp="$4"


 #Define Hi-C files
H1="${run_dir}/${sample_dir}/"*R1*.fastq.gz

for file in $H1; do
    echo "Hi-C forward: $file"
done

H2="${run_dir}/${sample_dir}/"*R2*.fastq.gz

for file in $H2; do
    echo "Hi-C reverse: $file"
done

asm="${run_dir}/${sample_dir}/"*.fasta

echo assembly: $asm

singularity run $SING/samtools_1.16.1.sif samtools faidx $asm && \
cut -f1,2 "${run_dir}/${sample_dir}/"*.fai > "${run_dir}/${sample_dir}/${OG}.genome" && \
singularity run $SING/bwa:0.7.17.sif bwa index $asm && \
singularity run $SING/bwa:0.7.17.sif bwa mem -5SP -T0 -t16 $asm $H1 $H2 -o "${run_dir}/${sample_dir}/${OG}.aligned.sam" && \

singularity run $SING/pairtools:1.1.0.sif pairtools parse --min-mapq 40 --walks-policy 5unique --max-inter-align-gap 30 --nproc-in 16 --nproc-out 16 --chroms-path "${run_dir}/${sample_dir}/${OG}.genome" "${run_dir}/${sample_dir}/${OG}.aligned.sam" > "${run_dir}/${sample_dir}/${OG}.parsed.pairsam" && \
singularity run $SING/pairtools:1.1.0.sif pairtools sort --tmpdir=$temp --nproc 16 "${run_dir}/${sample_dir}/${OG}.parsed.pairsam" > "${run_dir}/${sample_dir}/${OG}.sorted.pairsam" && \
singularity run $SING/pairtools:1.1.0.sif pairtools dedup --nproc-in 16 --nproc-out 16 --mark-dups --output-stats "${run_dir}/${sample_dir}/${OG}.stats.txt" --output "${run_dir}/${sample_dir}/${OG}.dedup.pairsam" "${run_dir}/${sample_dir}/${OG}.sorted.pairsam" && \
singularity run $SING/pairtools:1.1.0.sif pairtools split --nproc-in 16 --nproc-out 16 --output-pairs "${run_dir}/${sample_dir}/${OG}.mapped.pairs" --output-sam "${run_dir}/${sample_dir}/${OG}.unsorted.bam" "${run_dir}/${sample_dir}/${OG}.dedup.pairsam" && \
singularity run $SING/samtools_1.16.1.sif samtools sort -@16 -T $temp.bam -o "${run_dir}/${sample_dir}/${OG}.mapped.PT.bam" "${run_dir}/${sample_dir}/${OG}.unsorted.bam" && \
singularity run $SING/samtools_1.16.1.sif samtools index "${run_dir}/${sample_dir}/${OG}.mapped.PT.bam"


wait 

singularity run $SING/pairtools:1.1.0.sif python3 get_qc.py -p "${run_dir}/${sample_dir}/${OG}.stats.txt" && \
singularity run $SING/preseq:2.0.2.sif preseq lc_extrap -bam -pe -extrap 2.1e9 -step 1e8 -seg_len 1000000000 -output "${run_dir}/${sample_dir}/${OG}.out.preseq" "${run_dir}/${sample_dir}/${OG}.mapped.PT.bam"

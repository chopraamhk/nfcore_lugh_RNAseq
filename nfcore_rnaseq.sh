#!/bin/sh
#SBATCH --job-name="nf-core"
#SBATCH -o RNAseq.o%j
#SBATCH -e RNAseq.e%j
#SBATCH --mail-user=<>
#SBATCH --mail-type=ALL
#SBATCH --partition="highmem"
#SBATCH -N 1
#SBATCH --mem=50G

module load Anaconda3/2024.02-1 
module load java/1.8.0
conda activate nfcore

nextflow run nf-core/smrnaseq --input samples.csv --outdir results_rnaseq --genome GRCh38 -c local.config -profile singularity --seq_center genewiz_azenta


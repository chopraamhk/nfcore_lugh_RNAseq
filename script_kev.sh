#!/bin/bash
#SBATCH --time=3-16:00:00
#SBATCH --job-name="nfcore_rnaseq"
#SBATCH --output=nf_core_rnaseq_inhouse_bc_salmon_pseudo_20240624.out
#SBATCH --mail-user=k.ryan45@universityofgalway.ie
#SBATCH --mail-type=ALL
#SBATCH --mem-per-cpu=20G   # memory per cpu-core
#SBATCH -N 1 # number of nodes

start_time=$SECONDS
module load Anaconda3/2024.02-1
conda activate nf-23.04.1

cd /data/kryan/rna_seq_bc/
mkdir -p nf-core-rnaseq-inhouse-bc-salmonpseudo-20240724
cd nf-core-rnaseq-inhouse-bc-salmonpseudo-20240724
echo "Running nf-core/rnaseq on inhouse samples carrying out salmon pseudoalignment with inferential sampling - skip alignment and just use salmon to quantify - also add GibbSamples to add inferential replicates"

#NXF_VER=21.10.6 nextflow run kevinpryan/rnaseq -profile lugh,singularity --input /data2/kryan/inhouse_rnaseq/samplesheet_inhouse_data.csv --fasta /data/kryan/reference/GRCh38.primary_assembly.genome.fa --gtf /data/kryan/reference/gencode.v31.annotation.gtf --max_cpus 12 --outdir /data2/kryan/inhouse_rnaseq/inhouse_data_nfcore_results --deseq2_vst --star_index /data/kryan/rna_seq_bc/caf_subtypes/index/star

NXF_VER=23.04.1 /data/kryan/.conda/envs/nf-core/bin/nextflow run nf-core/rnaseq -r 3.14.0 -profile singularity -c /data/kryan/misc/nextflow/lugh_modified_local_for_change.config --input /data/kryan/rna_seq_bc/nf-core-rnaseq-inhouse-rerun-20240612/samplesheet_inhouse_rnaseq.csv --fasta /data/kryan/reference/GRCh38.primary_assembly.genome.fa --gtf /data/kryan/reference/genome_gencode_v45/gencode.v45.basic.annotation.gtf --outdir /data/kryan/rna_seq_bc/nf-core-rnaseq-inhouse-bc-salmonpseudo-20240724/outdir --deseq2_vst --seq_center genewiz_azenta --pseudo_aligner salmon --extra_salmon_quant_args '--numGibbsSamples 30' --skip_alignment

elapsed=$(( SECONDS - start_time ))
eval "echo Elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')"

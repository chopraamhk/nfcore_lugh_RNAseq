# nfcore_lugh_RNAseq
Instructions to run nf-core bulk RNAseq pipeline on University of Galway - lugh cluster 

Reference: https://nf-co.re/configs/lugh/

Step 1: Make a spreadsheet which has header:

sample,fastq_1,fastq_2,strandedness
Step 2:

python3 make_samplesheet.py -i path/to/folder/where/RNAseq_data/is/available
or if the file of each run is in a folder (sample(folder) --- R1 and R2) and you want to make one file at the end

python3 make_samplesheet1.py -i path/to/folder/where/RNAseq_data/is/available/Sample_* -o samplesheet1.csv
If getting into storage issues, split the csv file in groups of 20 and run the analysis

header=$(head -n1 samplesheet.csv); tail -n +2 samplesheet.csv | split -l 20 - samplesheet_ && for f in samplesheet_*; do (echo "$header"; cat "$f") > "${f}.csv"; rm "$f"; done
Step 3: Use local_config.sh and run the bash script

sbatch nfcore_bash.sh

import os
import argparse
import csv
import re
from collections import defaultdict

def generate_samplesheet(fastq_dir, output_file):
    """
    Parses a directory of paired-end FASTQ files to create a samplesheet.

    Args:
        fastq_dir (str): The path to the directory containing .fastq.gz files.
        output_file (str): The name of the output CSV file.
    """
    # Regex to capture the sample name from a FASTQ filename.
    # It captures the part before '_S##_L###_R#_001.fastq.gz'.
    sample_pattern = re.compile(r'(.+)_R1_001\.fastq\.gz')
    
    # Use a defaultdict to group lanes by sample name
    samples = defaultdict(list)

    # Find all R1 files and extract sample names
    for filename in sorted(os.listdir(fastq_dir)):
        if '_R1_001.fastq.gz' in filename:
            match = sample_pattern.match(filename)
            if match:
                sample_name = match.group(1)
                r1_path = os.path.join(fastq_dir, filename)
                
                # Create the corresponding R2 filename and check for its existence
                r2_filename = filename.replace('_R1_001.fastq.gz', '_R2_001.fastq.gz')
                r2_path = os.path.join(fastq_dir, r2_filename)
                
                if os.path.exists(r2_path):
                    samples[sample_name].append((r1_path, r2_path))
                else:
                    print(f"Warning: R2 file not found for {filename}. Skipping this pair.")

    if not samples:
        print(f"Error: No matching FASTQ file pairs found in '{fastq_dir}'.")
        return

    # Write the collected data to the CSV file
    try:
        with open(output_file, 'w', newline='') as f_out:
            writer = csv.writer(f_out)
            # Write the header
            writer.writerow(['sample', 'fastq_1', 'fastq_2', 'strandedness'])
            
            # Write the data for each sample
            for sample_name, pairs in samples.items():
                for r1_path, r2_path in pairs:
                    writer.writerow([sample_name, r1_path, r2_path, 'auto'])
        
        print(f" Samplesheet successfully created at: {output_file}")

    except IOError as e:
        print(f"Error writing to file {output_file}: {e}")


def main():
    """Main function to parse command-line arguments."""
    parser = argparse.ArgumentParser(description="Generate a samplesheet CSV from a directory of FASTQ files.")
    parser.add_argument(
        '-i', '--input_dir', 
        required=True, 
        help="Path to the directory containing FASTQ files."
    )
    parser.add_argument(
        '-o', '--output_file', 
        default='samplesheet.csv', 
        help="Name for the output CSV file (default: samplesheet.csv)."
    )
    args = parser.parse_args()
    
    generate_samplesheet(args.input_dir, args.output_file)


if __name__ == '__main__':
    main()

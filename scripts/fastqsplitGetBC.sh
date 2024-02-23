#!/bin/bash

exit 0

# FIFO not compatible with fastqsplitter

# script: fastqsplitgetBC.sh
# SP@NC 2024-02-15, v1.0
# depends on fastqsplitter (https://github.com/LUMC/fastqsplitter)

myenv=fastqsplitter
source /etc/profile.d/conda.sh
conda activate ${myenv} || \
  ( echo "# the conda environment ${myenv} was not found on this machine" ;
    echo "# please read the top part of the script!" \
    && exit 1 )

# Check if fastqsplitter command is available
if ! command -v fastqsplitter &> /dev/null; then
    echo "Error: fastqsplitter command not found. Please install fastqsplitter (https://github.com/LUMC/fastqsplitter)" >&2
    exit 1
fi

usage="Usage: $(basename "$0") -i <input_fastq> [-c <chunks (8)>] [-t <num_threads (2)>]"

while getopts ":i:c:t:" opt; do
    case $opt in
        i) infastq=$OPTARG ;;
        c) opt_chunks=$OPTARG ;;
        t) opt_nthr=$OPTARG ;;
        *) echo ${usage} >&2
           exit 1 ;;
    esac
done

# Default values
chunks=${opt_chunks:-8}
nthr=${opt_nthr:-2}

# Check if input fastq is provided
if [ -z "${infastq}" ]; then
    echo "Error: Input FASTQ file not provided." >&2
    echo ${usage} >&2
    exit 1
fi

# Extract prefix from input fastq
pfx=$(basename "${infastq%.f*}")

# create fifos
mkfifo $(seq -f "${pfx}_chunk_%g.fq.gz" 1 "${chunks}")

echo "# FIFO created, now processing data"

# create arguments for command
outputs=$(for chunk in $(seq -f "${pfx}_chunk_%g.fq.gz" 1 $chunks); do 
    echo -n "-o ${chunk} "; 
    done)


# custom bioawk function
function getBarcodesFromList() {

# run in parallel from chunks obtained from fastqsplit.sh 4632_96_BRB_R1.fastq.gz

len=14
bioawk -c fastx -v len="${len}" '
        BEGIN {
            while (getline < "'"$1"'") {
                id[$0]++;
            }
            close("'"$1"'")
        }
        {
            if (id[$name] > 0) {
                bc=substr($seq, 1, len)
                umi=substr($seq, len+1, length($seq))
                print $name"\t"bc"\t"umi
            }
        }' - ;
}

export getBarcodesFromList

# run fastqsplitter in background
fastqsplitter -i ${infastq} ${outputs} -t ${nthr} &

echo "# splitting initiated"

# apply in parallel on all chunks
for i in {1..8}; do
   zcat "4632_96_BRB_R1_chunk_${i}.fq.gz" \
     | getBarcodesFromList undetermined_readIDs.txt \
     > "id_barcode_umi_${i}.txt" &
done

echo "# parallel extarction initiated"

# wait for the fastqsplitter command to end
wait

# close FIFOs
rm $(seq -f "${pfx}_chunk_%g.fq.gz" 1 "${chunks}")

# create merge for next step
parsort id_barcode_umi_*.txt > id_barcode_umi.txt

# assemble results, sort and count
cut -f 2 id_barcode_umi.txt | parsort | uniq -c | sort -k 1n,1r > barcode_counts.txt
head -10 barcode_counts.txt

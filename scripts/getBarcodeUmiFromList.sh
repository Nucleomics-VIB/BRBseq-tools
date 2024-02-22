#!/bin/bash

# script getBarcodeUmiFromList.sh
# requires parsort from Ole Tange for parallel sorting

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

# apply in parallel on all chunks
for i in {1..8}; do
   zcat "4632_96_BRB_R1_chunk_${i}.fq.gz" | getBarcodesFromList undetermined_readIDs.txt > "id_barcode_umi_${i}.txt" &
done
wait

# create merge for next step
parsort id_barcode_umi_*.txt > id_barcode_umi.txt

# assemble results, sort and count
cut -f 2 id_barcode_umi.txt | parsort | uniq -c | sort -k 1n,1r > barcode_counts.txt
head -10 barcode_counts.txt

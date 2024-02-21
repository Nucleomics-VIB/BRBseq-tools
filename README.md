[(Nucleomics-VIB)](https://github.com/Nucleomics-VIB)
![BRBseq-tools](pictures/ngstools.png) - BRBSeq-Tools
==========

*All tools presented below have only been tested by me and may contain bugs, please let me know if you find some. Each tool relies on dependencies normally listed at the top of the code (cpan for perl and cran for R will help you add them)*

<h4>Please send comments and feedback to <a href="mailto:nucleomics.bioinformatics@vib.be">nucleomics.bioinformatics@vib.be</a></h4>

## Process BRB-Seq data obtained from the Aviti instrument

### Plot distance between barcodes used in one experiment to identify small-distance pairs

* BRB_distance2.R


The code can be tuned to color the distance in different ways, see script for details

![distance_gradient_plot](pictures/distance_gradient_plot.png)

![distance_gradient_plot_mid5](pictures/distance_gradient_plot_mid5.png)

![distance_gradient_plot_auto](pictures/distance_gradient_plot_auto.png)

As seen in the last plot, the minimal distance between non-identical barcodes is 4 (4 base substitutions) and should allow unambiguous demultiplexing.

### Get all variant barcodes with a distance of 1 from a user provided sequence

* list_distance1.pl

This utility takes one barcode as input and outputs it together with all single nucleotide variants (only substitutions). The output can be used to rescue reads from the undetermined fastq file after identifying them from the R1 file (done below)

### Custom functions to rescue barcode data from an aviti BRB-Seq run

A BRB-Seq run ended up with one sample having significantly less reads than the others

```
Demultiplexing Summary
Summary Nb_Reads        Percent
Total number of reads   1038831779      100
Undetermined Barcodes   17796238        1.71
Determined Barcodes     1021035541      98.29
```

One barcode (6607:AACAACCGAAGTAA) was giving too few reads and we thought that the corresponding barcode sequence (provided by the customer in Exp4632_barcodes.txt) could have been the problem.

We processed the data as follows:

![BRBSeq_rescue](pictures/BRBSeq_rescue.png)

The top barcode sequence identified from R1 sequences based on readIDs found in the undetermined fastq file are listed next.

```
CAATGCATTTCACC  467885
ACGGCCTTCAAAGT  205942
ATTCCTTTAAGTTT  151154
TCCAGCACCGGGCA  117733
TGTCTCTTATACAC  88274
CCTGTCTCTTATAC  87799
GTCTCTTATACACA  79008
ATACCTGTCTCTTA  78839
CTCCTAACACCTGT  67332
ATAATATCTGTCTC  63756
```

The readIDs of the top over-represented barcode CAATGCATTTCACC (N=467885) and its distance-1 relatives (obtained from ```list_distance1.pl CAATGCATTTCACC```) were used to extract UMI and barcode information from the R1 fastq file, and to recover R2 reads with matching readID names.
During rescue, the UMI and barcode were added to the extracted read headers before writing them to file (separated by '+').

The bioawk driven custom bash functions used for this analysis are found in scripts/ (txt files with name starting with 'fun')

After performing the analysis we found too few sequences associated with the top undetermined barcode to represent a missing barcode read group. It is therefore likely that the minor sample found in this run does not represent a wrong barcode in but rather a failed library prep for the corresponding sample due to input quality of the DNA or human error.
The code is provided here to be recycled for other purpose.

<hr>

![Creative Commons License](http://i.creativecommons.org/l/by-sa/3.0/88x31.png?raw=true)

This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).


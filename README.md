[(Nucleomics-VIB)](https://github.com/Nucleomics-VIB)
![BRBseq-tools](ngstools.png) - BRBSeq-Tools
==========

*All tools presented below have only been tested by me and may contain bugs, please let me know if you find some. Each tool relies on dependencies normally listed at the top of the code (cpan for perl and cran for R will help you add them)*

<h4>Please send comments and feedback to <a href="mailto:nucleomics.bioinformatics@vib.be">nucleomics.bioinformatics@vib.be</a></h4>

Process BRB-Seq data obtained from the Aviti instrument

### Plot distance between barcodes used in opne experiment to identify small-distance pairs

* BRB_distance2.R

The code can be tuned to color the distance in different ways, see script for details

![distance_gradient_plot](pictures/distance_gradient_plot.png)

![distance_gradient_plot_mid5](pictures/distance_gradient_plot_mid5.png)

![distance_gradient_plot_auto](pictures/distance_gradient_plot_auto.png)

### Get all variant barcodes with diatance 1 from a user provided sequence

* list_distance1.pl

### Custom functions to rescue barcode data from an aviti run

One barcode was giving too few reads and we thought that the corresponding barcode sequence (provided by the customer) could have been the problem.

We processed the data as follows:

![BRBSeq_rescue](pictures/BRBSeq_rescue.png)

The custom functions used for this analysis are listed next (names starting with 'fun')

<hr>

![Creative Commons License](http://i.creativecommons.org/l/by-sa/3.0/88x31.png?raw=true)

This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).


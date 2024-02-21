#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use Text::Levenshtein::Flexible;

# script: list_distance1.pl
# list all substitution variants with distance 1 from an input barcode
# Stéphane Plaisance - VIB-Nucleomics Core - 2024-02-21 v1.00
# visit our Git: https://github.com/Nucleomics-VIB

# Initialize variables
my $help; # Flag for displaying help message
my $input_string; # Variable to store input string

# Parse command-line options
GetOptions(
    "b=s" => \$input_string, # -b option for input string
    "help" => \$help, # Display help message
);

# Display help message if requested
if ($help) {
    print "Usage: $0 -b <input_string>\n";
    exit;
}

# Check if input string is provided
unless (defined $input_string) {
    die "Error: Please provide an input string using the -b option.\n";
}

# Length of the input string
my $length = length($input_string);

print "$input_string\n";

# Generate all possible variants with max distance 1
# only consider basecall errors = base substitutions

for my $i (0 .. $length - 1) {
    my $prefix = substr($input_string, 0, $i);
    my $suffix = substr($input_string, $i + 1);

    # Generate variants by substituting each character
    for my $char ('A', 'T', 'G', 'C') {
        my $variant = $prefix . $char . $suffix;
        next if uc($variant) eq uc($input_string); # Skip the original input
        print "$variant\n";
    }

    # Generate variants by deleting a character
    #my $deleted_variant = $prefix . $suffix;
    #print "$deleted_variant\n";

    # Generate variants by inserting a character
    #for my $char ('A', 'T', 'G', 'C') {
    #    my $inserted_variant = $prefix . $char . substr($input_string, $i);
    #    print "$inserted_variant\n";
    #}
}
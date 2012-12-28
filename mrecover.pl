#!/usr/bin/perl

use strict;
use warnings; 

# recovers back missing POS from MST parser output (CONLL setup) 

die "needs two files (conll input, and mstparsed conll output)" unless ($ARGV[1]); 
die "unable to read files" unless ((-r $ARGV[0]) and (-r $ARGV[1])); 

open FILERAW, "<", $ARGV[0]; 
open FILEPARSED, "<", $ARGV[1]; 

#for each line, 
while(<FILEPARSED>)
{
    my $parsed_line = $_; 
    my $raw_line = <FILERAW>; 
    my $output_line = $parsed_line; 

    # if this is not the separation line (empty) 
    if ($parsed_line =~ /\S/)
    {
	# sanity check (or die)
	# (lets check first 4 colums are same); 
	my @rawtab = split /\t/, $raw_line;
	my @parsedtab = split /\t/, $parsed_line; 

	die "sanity check fails! Two files are not of same input? $raw_line $parsed_line" unless (($rawtab[0] eq $parsedtab[0]) and ($rawtab[1] eq $parsedtab[1]) and ($rawtab[2] eq $parsedtab[2]) and ($rawtab[3] and $parsedtab[3])); 

	# replace the 5th tab from $raw_line one 
	$parsedtab[4] = $rawtab[4]; 

	# compose new output_line 
	$output_line = join('\t', @parsedtab); 
    }
    print $output_line; 
}

#!/usr/bin/perl
use strict;
use warnings;

# cut away the file into a set of files with each 1M sentences

# the script don't care about internal structure, it will count <sentence> for 1M count, and will write it as a separate file. 

my $filename_prefix = "sdewac_part"; 
my $filename_postfix = ".utf8.txt"; 
my $file_index=1; 
my $BREAK_AT = 1000000; #1M would make about 40 files  

die "usage: perl mcut.pl [sdewac_single_file]\n" unless ($ARGV[0]); 

open FILE, "<", $ARGV[0]; 

my $s_count = 0; 
my $filename = sprintf("%s%02d%s", $filename_prefix, $file_index, $filename_postfix); 
open OUTFILE, ">", $filename; 

while(<FILE>)
{
    if (/^<sentence>/)
    {
	$s_count++; 
	# 1M sentences already written? 
	if (($s_count % $BREAK_AT) == 0)
	{
	    close OUTFILE; 
	    $file_index++; 
	    $filename = sprintf("%s%02d%s", $filename_prefix, $file_index, $filename_postfix); 
	    open OUTFILE, ">", $filename; 
	    #open OUTFILE, ">", ($filename_prefix . $file_index . $filename_postfix); 
	}
    }    
    print OUTFILE $_; 
}

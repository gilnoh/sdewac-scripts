#!/usr/bin/perl
use warnings;
use strict; 

die unless $ARGV[0]; 
print STDERR "sanity checking...\n"; 
open FILE, "<", $ARGV[0]; 
my $prev=""; 
while (<FILE>)
{
    if (/<\/sentence>/) 
    {
	warn "</sentence> not with </s>\n" unless ($prev =~ /^<\/s>/); 
    }

    if (/<s>/)
    {
	warn "<s> not in place" unless ($prev =~ /<error=/); 
    }
    $prev = $_; 
}

#!/usr/bin/perl

use strict;
use warnings;

for(my $i=41; $i < 46; $i++)
{
    print "working on $i\n";
    my $argstring = sprintf("%02d", $i); 
    system("bash", "recovern.bash", "$argstring"); 
    open LOG, "<errlog"; 
    print while(<LOG>); 
}

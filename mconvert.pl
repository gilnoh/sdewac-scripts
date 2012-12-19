#!/usr/bin/perl

# this small script converts SDEWac format into CoNLL format 
# input comes from STDIN, output goes to STDOUT. 

use warnings; 
use strict; 

# grap one <sentence> - </sentence> 
# extract sentence part <s> - </s> 
# run convert_sentence 

sub convert_sentence(@)
{
    my @lines = @_; # the lines only holds actual data, not XML tags. 
    my $token_id=1; 

    foreach (@lines)
    {
	my @item = split /\s+/; 
	warn "Wrong input? : $_\n" unless (scalar (@item) != 3); 
	my $form = $item[0]; 
	my $pos = $item[1]; 
	my $lemma = $item[2]; 
	my $cpos = ucfirst $pos; 
	
	# ID, FORM, LEMMA, CPOSTAG, POSTAG, FEATS, HEAD, DEPREL
	print $token_id, "\t"; 
	print $form, "\t"; 
	print $lemma, "\t";  
	print $cpos, "\t"; 
	print $pos, "\t"; 
	print "_", "\t"; # no feature
	print "0", "\t"; # will be annotated by parser 
	print "UNKNOWN", "\t"; # will be annotated by parser 
	print "\n"; 
	# 

	$token_id++; 
    }
}

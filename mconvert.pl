#!/usr/bin/perl

# this small script converts SDEWac format into CoNLL format 
# input comes from STDIN, output goes to STDOUT. 

use warnings; 
use strict; 

sub extract_s(@);
sub convert_sentence(@); 

# grap one <sentence> - </sentence> 
my $catch=0; 
my @sentence; 
while(<STDIN>)
{
    $catch = 1 if (/^<sentence>/); 	# start capture
    if (/^<\/sentence>/)
    {
	# we've captured one full sentence. call <s> extractor
	my @s = extract_s(@sentence); 
	convert_sentence(@s); # this sub converts and prints the <s> content	
	print "\n"; # sentence separater... 

	# resetting variables for next iteration ... 
	@sentence=(); 
	$catch=0; 
    }
    if ($catch)
    {
	push @sentence, $_; 
    }
}


# extract sentence part <s> - </s>, from @array that holds <sentence> content. 
sub extract_s(@)
{
    my @input = @_; 

    # trim front until <s>
    while(1)
    {
	
	my $l = shift @input; 
	unless($l)
	{
	    warn "extract_s: possible missing <s>";
	    last;
	}
	last if ($l =~ /^<s>/); 
    }
    
    #sanity check 
    #warn "extract_s: ill formed input @input" unless (scalar (@input)); 
    
    # trim end till meeting </s> 
    while(scalar(@input))
    {
	my $l = pop @input; 
	last if ($l =~ /^<\/s>/)
    }

    #sanity check 
    warn "extract_s: ill formed input @_" unless (scalar (@input)); 

    return @input; 
}


# converts and prints single <s> content to STDOUT 
sub convert_sentence(@)
{
    my @lines = @_; # the lines only holds actual data, not XML tags. 
    my $token_id=1; 

    foreach (@lines)
    {
	my @item = split /\s+/; 
	warn "Wrong input? : $_\n" unless (scalar (@item) == 3); 
	my $form = $item[0]; 
	my $pos = $item[1]; 
	my $lemma = $item[2]; 
	my $cpos = substr $pos, 0, 1; 
	
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

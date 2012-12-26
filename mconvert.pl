#!/usr/bin/perl

# this small script converts SDEWac format into CoNLL format 
# input comes from STDIN, output goes to STDOUT. 

# note that there are lots of <s></s> construct without <sentence>. 
# (so no source, error, etc marups. ) 
# The script checks them and ignores such cases. It converts only 
# the well-formed <sentence></sentence> structures. It outpus the line 
# number of ill-formed input in STDERR 

use warnings; 
use strict; 

sub extract_s(@);
sub convert_sentence(@); 

# grap one <sentence> - </sentence> 
my $catch=0; 
my @sentence; 
my $count_illformed_sentence_end = 0;
my $count_sentence_end = 0; 
while(<STDIN>)
{
    $catch = 1 if (/^<sentence>/); 	# start capture
    if (/^<\/sentence>/)
    {
	$count_sentence_end++; 
	# sanity check 
	if ($catch != 1)
	{
	    warn "Ill-formed input skipped (<\/sentence> without <sentence>)"; 
	    $count_illformed_sentence_end++; 
	    next; 
	}

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

print STDERR "number of <sentence></sentence> mismatch: $count_illformed_sentence_end\n"; 
print STDERR "(out of number of </sentence>: $count_sentence_end)\n"; 

# extract sentence part <s> - </s>, from @array that holds <sentence> content. 
sub extract_s(@)
{
    my @input = @_; 

    warn "extract_s: empty input!" unless (scalar(@input)); 
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
	my @item = split /\t/; 
	warn "Wrong input? : $_\n" unless (scalar (@item) == 3); 
	my $form = $item[0]; 
	my $pos = $item[1]; 
	my $lemma = $item[2]; 
	my $cpos = substr $pos, 0, 1; 

	# trim form, pos and lemma (removing trailing whitespace(s), if any)
	$lemma =~ s/\s+$//; 
	$form =~ s/\s+$//; 
	$pos =~ s/\s+$//; 

	
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

#!/usr/bin/env perl

###Takes a multiFASTA file and prints one sequence per new file

use strict;
use warnings;
use Getopt::Long;

my ($fasta, %scaffolds, $scaffold);

my $usage = "You need to provide --fasta\n";

GetOptions(
	'fasta=s' => \$fasta,
) or die "$usage";

unless (defined $fasta){ die "$usage";}

open FASTA, '<', $fasta or die "can't open fasta";

while (<FASTA>){
	if (/>(.[^\s]+)/){
		$scaffold = $1;
		}
	else {
		if (defined $scaffolds{$scaffold}){
			$scaffolds{$scaffold} .= $_;
		}
		else {
			$scaffolds{$scaffold} = $_;
		}
	}
}

foreach $scaffold (keys %scaffolds){
	open FH, '>', $scaffold.'.fa';
	print FH ">$scaffold\n$scaffolds{$scaffold}";
	close FH;
}


#!/usr/bin/env perl

##prints sequence lengths from a FASTA file.

use strict;
use warnings;
use Getopt::Long;

my ($fasta, %scaffold_lengths, $scaffold_name);

my $usage = "You need to provide --fasta\n";

GetOptions(
	'fasta=s' => \$fasta,
) or die "$usage";

unless (defined $fasta){ die "$usage";}

open FASTA, '<', $fasta or die "can't open fasta";

while (<FASTA>){
	if (/>(.+)/){
		$scaffold_name = $1;
		$scaffold_lengths{$scaffold_name} = 0;
	}
	else {
		chomp;
		s/^\s//;
		my $bp = length $_;
		$scaffold_lengths{$scaffold_name} += $bp;
	}
}

foreach $scaffold_name (keys %scaffold_lengths){
	print "$scaffold_name\t$scaffold_lengths{$scaffold_name}\n";
}


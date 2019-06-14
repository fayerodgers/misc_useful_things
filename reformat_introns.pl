#!/usr/bin/env perl

use strict;
use warnings;

open FH, '<', $ARGV[0];

while (<FH>){
	my @temp = split '\t', $_;
	my $contig = $temp[0];
	my $exon1_start = $temp[1];
	my $exon2_end = $temp[2];
	my $junct = $temp[3];
	my $score = $temp[4];
	if ($score > 3){ 
		my @intron_coords = split ',', $temp[10];
		my $exon1_length = $intron_coords[0];
		my $exon2_length = $intron_coords[1];
		my $intron_start = $exon1_start + $exon1_length;
		my $intron_end = $exon2_end - $exon2_length;
		print "$contig\t$intron_start\t$intron_end\t$score\t$score\t.\t$intron_start\t$intron_end\n";
	}
}

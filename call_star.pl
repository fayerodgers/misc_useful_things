use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;

my ($index_dir, $annotation, $files, %samples);

my $usage = "--index_dir - path to genome index
--annotation - GFF
--files - a text with sample names and fastq file locations";

GetOptions(
	'index_dir=s' => \$index_dir,
	'annotation=s' => \$annotation,
	'files=s' => \$files
) or die "$usage";

foreach my $var ($index_dir, $annotation, $files){
	unless (defined $var){die "$usage"; }
}

open FASTQS, '<', $files or die "can't open $files";

while(<FASTQS>){
	my @temp = split('\s+',$_);
	$temp[1] =~ s/_[12].fastq.gz//;
	$samples{$temp[0]}{$temp[1]} = '';
}

foreach my $sample (keys %samples){
	mkdir $sample;
	my @read_1 = map($_."_1.fastq.gz", keys(%{$samples{$sample}}));
	my $read_1 = join(',', @read_1);
        my @read_2 = map($_."_2.fastq.gz", keys(%{$samples{$sample}}));
        my $read_2 = join(',', @read_2);
	my $star = "bsub -o ".${sample}."/map.o -e ".${sample}."/map.e -R'select[mem>=30000] rusage[mem=30000] span[hosts=1]' -M 30000 -n 8 STAR --sjdbGTFfile ".$annotation." --runThreadN 8 --genomeDir ".$index_dir." --readFilesIn ".$read_1." ".$read_2." --readFilesCommand gunzip -c --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverReadLmax 0.04 --alignIntronMin 20 --alignIntronMax 1000000 --alignMatesGapMax 1000000 --outFileNamePrefix ".${sample}."/".${sample}." --outSAMtype BAM Unsorted"; 
	#print $star;
	system($star);
}

#print Dumper \%samples;

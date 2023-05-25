use strict;
my $blockfile=shift;
my $vcf=shift;
my $out=shift;
open OUT,">$out" or die $!;
my %bins;
open LF,$blockfile or die $!;
while (<LF>) {
	chomp;
	my @a=split/\s+/;
	my $chr=$a[0];
	my $st=$a[1];
	my $en=$a[2];
	for (my $loc=$st;$loc<=$en ;$loc++) {
		$bins{$chr}{$loc}="$chr\_$st\_$en";
	}
}
close LF;


my %vcf;
open LF,$vcf=~/gz$/?"zcat $vcf|":"<$vcf" or die $!;
while (<LF>) {
	chomp;
	my @a=split/\s+/;
	my $chr=$a[0];
	my $pos=$a[1];
	if(exists $bins{$chr}{$pos}){
		print OUT "$bins{$chr}{$pos}\t$_\n"
	}
}
close LF;
close OUT;




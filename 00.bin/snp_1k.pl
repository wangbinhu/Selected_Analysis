use strict;
my $in=shift;

my $out=shift;
my %hash;

open OUT,">$out" or die $!;
open IN,$in or die $!;
while(<IN>){
    chomp;
    my $a=$_;
    my @a=split/\s+/,$a;
    my @b=split/\s+/,$a,2;
    my $chr=$a[1]; 
    my $pos=int($a[2]/5000); 
    if(exists $hash{$chr}{$pos}){
       next;
    }
    my $vcf=$b[1];
    print OUT "$vcf\n";
    $hash{$chr}{$pos}=0;
}
close IN;
close OUT;

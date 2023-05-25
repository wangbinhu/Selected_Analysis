use strict;
use v5.10;

my $IN1_Bed_File=shift;
my $IN2_Vcf=shift;
my $OU3_Vcf=shift;

open OU3,">$OU3_Vcf" or die $!;


my %bins;
open IN1, $IN1_Bed_File or die $!;
while (<IN1>) {
        chomp;
        my @a=split/\s+/;
        my $chr=$a[0];
        my $st=$a[1];
        my $en=$a[2];
        for (my $loc=$st;$loc<=$en ;$loc++) {
                $bins{$chr}{$loc}="$chr\_$st\_$en";
        }
}
close IN1;

open IN2, $IN2_Vcf=~/gz$/?"zcat $IN2_Vcf|":"<$IN2_Vcf" or die $!;
while (<IN2>) {
        chomp;
        if ($_ =~/^\#/) {say OU3  "$_"; next} ;

        my @a=split/\s+/;
        my $chr=$a[0];
        my $pos=$a[1];
        if(exists $bins{$chr}{$pos}){
                say OU3 $_;
        }
        }
close IN2;
close OU3;

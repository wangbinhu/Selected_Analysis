
#!/usr/bin/perl
############################################################################
use strict;
use warnings;
use PerlIO::gzip;
die "perl $0 <fst> <pi1> <pi2> <SNP_Num_windowed_threshold>" unless @ARGV==4;
open IN1, "$ARGV[0]" or die $!;
open IN2, "$ARGV[1]" or die $!;
open IN3, "$ARGV[2]" or die $!;

my $snp_num_w=$ARGV[3];
my %fst;
my %piA;
my %piB;
my %id;
while(my $line=<IN1>){
    chomp $line;
    next if ($line=~/^CH/);
    my @tmp = split (/\s+/, $line);    
    my $id=join("-",$tmp[0],$tmp[1],$tmp[2]);
    $id{$id}="";
    if($tmp[3]>$snp_num_w){
    	$fst{$id}=$line;	
    }
		
}
while(my $line=<IN2>){
    chomp $line;
    next if ($line=~/^CH/);
    my @tmp = split (/\s+/, $line);
        my $id=join("-",$tmp[0],$tmp[1],$tmp[2]);
          $id{$id}="";
          if($tmp[3]>$snp_num_w){
            $piA{$id}=$line;
          }
  	}
    
while(my $line=<IN3>){
    chomp $line;
    next if ($line=~/^CH/);
    my @tmp = split (/\s+/, $line);
        my $id=join("-",$tmp[0],$tmp[1],$tmp[2]);
          $id{$id}="";
          if($tmp[3]>$snp_num_w){
                    $piB{$id}=$line;}
                    }
    
close IN1;
close IN2;
close IN3;

print "CHROM\tBIN_START\tBIN_END\tfstW\tpi-1\tpi-2\n";
foreach my $id(keys %id){
	if(exists $fst{$id} and exists $piA{$id} and exists $piB{$id} ){
		my @fst=split(/\s+/,$fst{$id});
		my @piA=split(/\s+/,$piA{$id});
		my @piB=split(/\s+/,$piB{$id});
		my $fstW=$fst[4];
		
		print "$fst[0]\t$fst[1]\t$fst[2]\t$fstW\t$piA[$#piA]\t$piB[$#piB]\n";
	}
	
	
}

sub log10 {        
	my $n = shift;        
	return -log($n)/log(10);    
}   

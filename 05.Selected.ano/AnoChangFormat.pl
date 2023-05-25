#!/usr/bin/perl -w
use strict;
#explanation:this program is edited to
#edit by hewm;   Thu Aug  7 15:41:49 CST 2014
#Version 1.0    hewm@genomics.org.cn

die  "Version 1.0\t2014-08-07;\nUsage: $0 <InPut.gz> <OutPut>\n" unless (@ARGV ==2);

#############Befor  Start  , open the files ####################

open (IA,"gzip -cd $ARGV[0] |  ") || die "input file can't open $!";
open (OA,">$ARGV[1]") || die "output file can't open $!" ;

################ Do what you want to do #######################
my %hash=();
while(<IA>)
{
	chomp ;
	my @inf=split ;
	   $inf[-1]=~s/:/_/g;
	my $v="$inf[-3]:$inf[-1]";
	my $key=$inf[0]."\t".$inf[1];
	if (!exists  $hash{$key} )
	{
		$hash{$key}=$v;
	}
	else
	{
		$hash{$key}="$hash{$key},$v";
	}
}
close IA;

foreach my $k (keys %hash)
{
	print OA  $k,"\t$hash{$k}\n";
}

close OA ;

######################swimming in the sky and flying in the sea ###########################


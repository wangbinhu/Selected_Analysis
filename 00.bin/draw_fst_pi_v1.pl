#!/usr/bin/perl
use Statistics::Descriptive;
use warnings;


die "perl $0 <merged_pop.diversity> <type Ratio[A-B]> <top%>" unless @ARGV==3;
open IN, "$ARGV[0]" or die $!;
my ($popA, $popB)=split(/-/,$ARGV[1]);
my @PIA;
my @PIB;
my @Fst;

while(my $line=<IN>)
{
    chomp $line;
    next if ($line=~/^[#C]/);
    my @tmp = split /\s+/, $line;
    push @Fst,$tmp[3];
    push @PIA,$tmp[4];
    push @PIB,$tmp[5];
}
my $numfst= @Fst;
my $numtop5= int ($numfst * $ARGV[2]);
my ($pi_AB_top5,$pi_BA_top5,$fst_top5)=&get_pi_fst_top5_threshold(\@PIA,\@PIB,\@Fst);
close IN;
open IN, "$ARGV[0]" or die $!;
open OUT5AB, ">$popA-vs-$popB.$ARGV[2].$popB.selected" or die $!;
open OUT5ABAll, ">$popA-vs-$popB.$ARGV[2].all" or die $!;
open OUT5BA, ">$popB-vs-$popA.$ARGV[2].$popA.selected" or die $!;
open OUT5BAAll, ">$popB-vs-$popA.$ARGV[2].all" or die $!;
print OUT5AB "CHROM\tBIN_START\tBIN_END\tfstW\tpi-A\tpi-B\tlog2(pia/pib)\tfst\n";
print OUT5BA "CHROM\tBIN_START\tBIN_END\tfstW\tpi-A\tpi-B\tlog2(pib/pia)\tfst\n";

while(my $line=<IN>)
{
    chomp $line;
    next if ($line=~/^[#C]/);
    my @tmp = split (/\t/, $line);
    my $AratioB=log($tmp[4]/$tmp[5])/log(2);
    my $BratioA=log($tmp[5]/$tmp[4])/log(2);
    if ($AratioB>=$pi_AB_top5 and $tmp[3]>=$fst_top5)
    {
   	 print OUT5AB "$line\t$AratioB\t$tmp[3]\n";
   	 print OUT5ABAll "$line\t$AratioB\t$tmp[3]\tup5\n";
    }else{
        print OUT5ABAll "$line\t$AratioB\t$tmp[3]\tno\n";
    }

    if ($BratioA>=$pi_BA_top5 and $tmp[3]>=$fst_top5)
    {
   	 print OUT5BA "$line\t$BratioA\t$tmp[3]\n";
   	 print OUT5BAAll "$line\t$BratioA\t$tmp[3]\tup5\n";
    }else{
        print OUT5BAAll "$line\t$BratioA\t$tmp[3]\tno\n";
    }
}
print "pi_AB_top5\tpi_BA_top5\tfst_top5\n";
print "$pi_AB_top5\t$pi_BA_top5\t$fst_top5\n";
close IN;
close OUT5AB;
close OUT5ABAll;
close OUT5BA;
close OUT5ABAll;

sub get_pi_fst_top5_threshold()
{
	my $piA =shift @_;
	my $piB =shift @_;
	my $fst =shift @_;
	my @AratioB_pi;
	my @BratioA_pi;
	my $pi_AB_top5;
	my $pi_BA_top5;
	my $fst_top5;
	
	for (my $i=0;$i<@{$piA};$i++)
	{
		push(@AratioB_pi,log(${$piA}[$i]/${$piB}[$i])/log(2));
		push(@BratioA_pi,log(${$piB}[$i]/${$piA}[$i])/log(2));
	}
	my $i;
	my $j;
	my $k;
	foreach  my $element (sort {$b <=> $a} @AratioB_pi)
	{
        $i++;
        if ($i == $numtop5) {$pi_AB_top5= $element;}
	}
	foreach  my $element (sort {$b <=> $a} @BratioA_pi)
	{
        $j++;
        if ($j == $numtop5) {$pi_BA_top5= $element;}
	}
	foreach  my $element (sort {$b <=> $a} @{$fst})
	{
        $k++;
        if ($k == $numtop5) {$fst_top5= $element;}
	}
	return $pi_AB_top5,$pi_BA_top5,$fst_top5;
}
sub Z_transfer()
{
	my $data=shift @_;
	my $stat=Statistics::Descriptive::Full->new();
	$stat->add_data(\@{$data});
	my$mean=$stat->mean();
	my$sd=$stat->standard_deviation();
	my@z_result=();
	for (my $i=0;$i<@{$data};$i++){
		my$a=(${$data}[$i]-$mean)/$sd;
		push @z_result,$a;
	}
	return @z_result;
}
sub log2()
{
	my $n = shift @_;
	my @log_result=();
        for (my $i=0;$i<@{$n};$i++){
        	my $a=log(${$n}[$i])/log(2);
		push @log_result,$a;
	}

 	return @log_result;

}

my $draw_r_AB=<<END;
library(RColorBrewer)
#mycol<-brewer.pal(8,"Set1")
mycol<-c("black","red","blue","green")
filein<-"$popA-vs-$popB.$ARGV[2].all"
palette(mycol)
data<-read.table(filein,sep="\\t",header=F)
win_total<-nrow(data)
pdf("$popA-vs-$popB.$ARGV[2].$popB.selected.region.pi_fst.pdf",h=10,w=10)
layout(matrix(c(2,0,1,3),2,2,byrow=TRUE), widths=c(3,1),heights=c(1,3), TRUE)
#-----------------------------------------------------------------------------------
##the first

par(mar=c(5.1,5.1,0.1,0))
for(i in 1:length(data[,8]))
{ if(data[i,8]<0)
  data[i,8]=0
}
plot(data[,8]~data[,7],pch=19,col=as.integer(data[,dim(data)[2]]),xlab="log2(Pi ratio(Pi$popA/Pi$popB))",ylab="Fst",cex=0.5,cex.lab=1.5,cex.axis=1.5)
legend("topleft",legend="$popB selected region",pch=19,col=2,bty="n",cex=2)

abline(h=$fst_top5,col="black",lty=2,lwd=2)
abline(v=$pi_AB_top5,col="black",lty=2,lwd=2)
#-----------------------------------------------------------------------------------
##the second

par(mar=c(0,5.1,3,0))
pi_hist<-hist(data[,7],breaks=seq(from=min(data[,7]),to=max(data[,7]),length.out=120),plot=FALSE)
pi_hist\$counts2<-pi_hist\$counts*100/sum(pi_hist\$counts)
hist(data[,7],breaks=seq(from=min(data[,7]),to=max(data[,7]),length.out=120),ann=FALSE,axes=T,xaxt="n",yaxt="n",xlab='', ylab='',col=3,border=3,main="Pi density")
y_pi_pos<-seq(0,max(pi_hist\$counts),length.out=6)
y_pi_label<-round(y_pi_pos*100/sum(pi_hist\$counts),digits=0)
y_pi_pos<-y_pi_label*dim(data)[1]/100
axis(side=2, y_pi_pos,labels=FALSE)
mtext(y_pi_label,side=2,las=1,at=y_pi_pos, line=0.8, cex=1.2)
mtext("Frequence (%)",side=2, line=3, at=max(pi_hist\$counts)/2,cex=1.2)
abline(v=$pi_AB_top5,col="black",lty=2,lwd=2)
par(new=T,ann=F)
par(mar=c(0,4.1,3,0))
num<-length(unique(data[,7]))
pi_cum<-array(0:0,c(num,2))
j=1
for(i in sort(unique(data[,7]))){
        pi_cum[j,1]=i
        pi_cum[j,2]=(colSums(data[,c(7,8)]<=i)[1])*100/dim(data)[1]
        j=j+1
}
plot(pi_cum[,1],pi_cum[,2],type='l', lwd=1, bty='n',xaxt='n',yaxt='n', xlab='', ylab='', ylim=c(0, 100))
y_pi_cum_pos <- seq(0,100,by=20)
axis(side=4, y_pi_cum_pos,labels=FALSE)
mtext(y_pi_cum_pos,side=4,las=1,at=y_pi_cum_pos, line=0.8, cex=1.2)
mtext('Cumulative (%)',side=4, line=3, at=median(y_pi_cum_pos)+10, cex=1.2 )

par(mar=c(5.1,0.2,0.1,1))
num<-length(unique(data[,8]))
fst_cum<-array(0:0,c(num,2))
j=1
for(i in sort(unique(data[,8]))){
        fst_cum[j,1]=i
        fst_cum[j,2]=(colSums(data[,c(7,8)]<=i)[2])*100/dim(data)[1]
        j=j+1
}
plot(fst_cum[,2],fst_cum[,1],type='l', lwd=1, bty='n',xaxt='n',yaxt='n', xlab='', ylab='', ylim=c(min(data[,8]),max(data[,8])))
y_fst_cum_pos <- seq(0,100,by=20)
axis(side=3, y_fst_cum_pos,labels=FALSE)
mtext(y_fst_cum_pos,side=3,las=1,at=y_fst_cum_pos, line=0.8, cex=1.2)
mtext('Cumulative (%)',side=3, line=3, at=median(y_fst_cum_pos)+10, cex=1.2 )
abline(h=$fst_top5,col="black",lty=2,lwd=2)
par(new=T,ann=F)
yhist <- hist(data[,8],breaks=seq(from=min(data[,8]),to=max(data[,8]),length.out=100),plot=FALSE)
par(mar=c(5.1,0.35,0.1,1))
#barplot(yhist\$density,horiz=TRUE,space=0,axes=T,col=rgb(0,1,0,alpha=0.5),main="",cex.axis=1.5,border=rgb(0,1,0,alpha=0.5))
barplot(yhist\$density,horiz=TRUE,space=0,xaxt="n",yaxt="n",col=rgb(0,1,0,alpha=0.5),main="",cex.axis=1.5,border=rgb(0,1,0,alpha=0.5))
x_fst_pos<-seq(0,max(yhist\$density),length.out=6)
x_fst_label<-round(x_fst_pos*100/sum(yhist\$density),digits=0)
axis(side=1,labels=x_fst_label,at=x_fst_pos)
mtext("Frequence (%)",side=1, line=3, at=max(yhist\$density)/2,cex=1.2)
dev.off()
q(save="no")
END

my $draw_r_BA=<<END;
library(RColorBrewer)
#mycol<-brewer.pal(8,"Set1")
mycol<-c("black","red","blue","green")
filein<-"$popB-vs-$popA.$ARGV[2].all"
palette(mycol)
data<-read.table(filein,sep="\\t",header=F)
win_total<-nrow(data)
pdf("$popB-vs-$popA.$ARGV[2].$popA.selected.region.pi_fst.pdf",h=10,w=10)
layout(matrix(c(2,0,1,3),2,2,byrow=TRUE), widths=c(3,1),heights=c(1,3), TRUE)
#-----------------------------------------------------------------------------------
###the first#

par(mar=c(5.1,5.1,0.1,0))
for(i in 1:length(data[,8]))
{ if(data[i,8]<0)
  data[i,8]=0
}
plot(data[,8]~data[,7],pch=19,col=as.integer(data[,dim(data)[2]]),xlab="log2(Pi ratio(Pi$popB/Pi$popA))",ylab="Fst",cex.lab=1.5,cex.axis=1.5,cex=0.5)
legend("topleft",legend="$popA selected region",pch=19,col=2,bty="n",cex=2)
abline(h=$fst_top5,col="black",lty=2,lwd=2)
abline(v=$pi_BA_top5,col="black",lty=2,lwd=2)
#-----------------------------------------------------------------------------------
###the second

par(mar=c(0,5.1,3,0))
pi_hist<-hist(data[,7],breaks=seq(from=min(data[,7]),to=max(data[,7]),length.out=120),plot=FALSE)
pi_hist\$counts2<-pi_hist\$counts*100/sum(pi_hist\$counts)
hist(data[,7],breaks=seq(from=min(data[,7]),to=max(data[,7]),length.out=120),ann=FALSE,axes=T,xaxt="n",yaxt="n",xlab='', ylab='',col=3,border=3,main="Pi density")
y_pi_pos<-seq(0,max(pi_hist\$counts),length.out=6)
y_pi_label<-round(y_pi_pos*100/sum(pi_hist\$counts),digits=0)
y_pi_pos<-y_pi_label*dim(data)[1]/100
axis(side=2, y_pi_pos,labels=FALSE)
mtext(y_pi_label,side=2,las=1,at=y_pi_pos, line=0.8, cex=1.2)
mtext("Frequence (%)",side=2, line=3, at=max(pi_hist\$counts)/2,cex=1.2)
abline(v=$pi_BA_top5,col="black",lty=2,lwd=2)
par(new=T,ann=F)
par(mar=c(0,4.1,3,0))
num<-length(unique(data[,7]))
pi_cum<-array(0:0,c(num,2))
j=1
for(i in sort(unique(data[,7]))){
        pi_cum[j,1]=i
        pi_cum[j,2]=(colSums(data[,c(7,8)]<=i)[1])*100/dim(data)[1]
        j=j+1
}
plot(pi_cum[,1],pi_cum[,2],type='l', lwd=1, bty='n',xaxt='n',yaxt='n', xlab='', ylab='', ylim=c(0, 100))
y_pi_cum_pos <- seq(0,100,by=20)
axis(side=4, y_pi_cum_pos,labels=FALSE)
mtext(y_pi_cum_pos,side=4,las=1,at=y_pi_cum_pos, line=0.8, cex=1.2)
mtext('Cumulative (%)',side=4, line=3, at=median(y_pi_cum_pos)+10, cex=1.2)

par(mar=c(5.1,0.2,0.1,1))
num<-length(unique(data[,8]))
fst_cum<-array(0:0,c(num,2))
j=1
for(i in sort(unique(data[,8]))){
        fst_cum[j,1]=i
        fst_cum[j,2]=(colSums(data[,c(7,8)]<=i)[2])*100/dim(data)[1]
        j=j+1
}
plot(fst_cum[,2],fst_cum[,1],type='l', lwd=1, bty='n',xaxt='n',yaxt='n', xlab='', ylab='', ylim=c(min(data[,8]),max(data[,8])))
y_fst_cum_pos <- seq(0,100,by=20)
axis(side=3, y_fst_cum_pos,labels=FALSE)
mtext(y_fst_cum_pos,side=3,las=1,at=y_fst_cum_pos, line=0.8, cex=1.2)
mtext('Cumulative (%)',side=3, line=3, at=median(y_fst_cum_pos)+10, cex=1.2)
abline(h=$fst_top5,col="black",lty=2,lwd=2)
par(new=T,ann=F)
yhist <- hist(data[,8],breaks=seq(from=min(data[,8]),to=max(data[,8]),length.out=100),plot=FALSE)
par(mar=c(5.1,0.35,0.1,1))
#barplot(yhist\$density,horiz=TRUE,space=0,axes=T,col=rgb(0,1,0,alpha=0.5),main="",cex.axis=1.5,border=rgb(0,1,0,alpha=0.5))
barplot(yhist\$density,horiz=TRUE,space=0,xaxt="n",yaxt="n",col=rgb(0,1,0,alpha=0.5),main="",cex.axis=1.5,border=rgb(0,1,0,alpha=0.5))
x_fst_pos<-seq(0,max(yhist\$density),length.out=6)
x_fst_label<-round(x_fst_pos*100/sum(yhist\$density),digits=0)
axis(side=1,labels=x_fst_label,at=x_fst_pos)
mtext("Frequence (%)",side=1, line=3, at=max(yhist\$density)/2,cex=1.2)
dev.off()
q(save="no")
END
open OUT , ">$popA-vs-$popB.$ARGV[2].draw.r";
print OUT "$draw_r_AB";
close OUT;
open OUT , ">$popB-vs-$popA.$ARGV[2].draw.r";
print OUT "$draw_r_BA";
close OUT;
system("/public/home/bgiadmin/anaconda3/envs/R351/bin/Rscript $popA-vs-$popB.$ARGV[2].draw.r");
system("/public/home/bgiadmin/anaconda3/envs/R351/bin/Rscript $popB-vs-$popA.$ARGV[2].draw.r");


Final_snp_vcf=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/03.gatk/02.gvcf.to.bed.gvcf/01.all.bed.chr/Final.final_snp.vcf.gz

# software:
source /public/home/bgiadmin/vcftools.sh;
vcftools=/public/home/bgiadmin/Software/08.ReqTools/vcftools/bin/vcftools
bcftools=/public/home/bgiadmin/Software/08.ReqTools/bcftools-1.9/bin/bcftools
bgzip=/public/home/bgiadmin/Software/tabix-0.2.6/bgzip
block2snp=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/09.selected.analysis/05.Selected.ano/block2snp.pl
block2snp_5k=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/09.selected.analysis/05.Selected.ano/block2snp_5k.pl


# Filter all vcf:
# $vcftools    --gzvcf    $Final_snp_vcf    --min-meanDP  2    --recode --recode-INFO-all  --maf 0.005    --max-missing 0.1    --out    ./All_Sample;
# mv    ./All_Sample.recode.vcf    ./All_Sample.vcf;
$bgzip    -c  ./All_Sample.vcf  >  ./All_Sample.vcf.gz;
$bcftools    index    ./All_Sample.vcf.gz;


# find /public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/09.selected.analysis/04.Selected |grep selected$ |xargs -I {} cat {} | awk '{print $1"\t"$2"\t"$3 }' | sort | uniq | grep -v CHROM > all.selected.bed

sed -i "s/chr/Cala/g"     all.selected.bed
perl    $block2snp        all.selected.bed    ./All_Sample.vcf.gz    all.selected.block2snp.xls
perl    $fillter_gff      all.selected.block2snp.xls    all.selected.block2snp.ano


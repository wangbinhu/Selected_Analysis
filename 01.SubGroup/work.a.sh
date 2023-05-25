Final_snp_vcf=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/03.gatk/02.gvcf.to.bed.gvcf/01.all.bed.chr/Final.final_snp.vcf.gz

# software:
source /public/home/bgiadmin/vcftools.sh;
vcftools=/public/home/bgiadmin/Software/08.ReqTools/vcftools/bin/vcftools
bcftools=/public/home/bgiadmin/Software/08.ReqTools/bcftools-1.9/bin/bcftools
bgzip=/public/home/bgiadmin/Software/tabix-0.2.6/bgzip

# Filter all vcf:
$vcftools    --gzvcf    $Final_snp_vcf    --min-meanDP  2    --recode --recode-INFO-all  --maf 0.005    --max-missing 0.1    --out    ./All_Sample; 
mv    ./All_Sample.recode.vcf    ./All_Sample.vcf;
$bgzip    ./All_Sample.vcf;
$bcftools    index    ./All_Sample.vcf.gz;

wk_dir=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/09.selected.analysis/

# software:
source /public/home/bgiadmin/vcftools.sh;
vcftools=/public/home/bgiadmin/Software/08.ReqTools/vcftools/bin/vcftools
bcftools=/public/home/bgiadmin/Software/08.ReqTools/bcftools-1.9/bin/bcftools
bgzip=/public/home/bgiadmin/Software/tabix-0.2.6/bgzip
iTools=/public/home/bgiadmin/Software/08.ReqTools/iTools_Code/iTools
Final_snp_vcf=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/03.gatk/02.gvcf.to.bed.gvcf/01.all.bed.chr/Final.final_snp.vcf.gz
Ref_gff=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/00.ref/Caln_genome.gff
AnoChangFormat=/public/home/bgiadmin/Software/10.User-defined/WBH/DNA_Reseq_One/07.RunGATK//AnoChangFormat.pl 
bed2vcf=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/09.selected.analysis/05.Selected.ano/bed2vcf.pl
All_Sample_vcf=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/09.selected.analysis/05.Selected.ano/All_Sample.vcf.gz

Group_List=(CH DJK LZH MH QDH XKH);

Group_List_len=${#Group_List[@]};
for ((i=0;i<=(Group_List_len-1);i++))
do
    for((j=i+1;j<=(Group_List_len-1);j++))
    do

    # mkdir  -p $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}
    # cd     $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}
    # perl   $wk_dir/00.bin/fst_pi_common.pl    $wk_dir/02.FST/${Group_List[$i]}.VS.${Group_List[$j]}.fst.windowed.weir.fst   $wk_dir/03.Poly//${Group_List[$i]}.window10000.windowed.pi    $wk_dir/03.Poly/${Group_List[$j]}.window10000.windowed.pi  0   | sort -k1,1 -k2,2n > $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.diversity
    # cat     $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.diversity  | grep Cala > $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.chr.diversity
    # sed    -i s/Cala/chr/g       $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.chr.diversity
    # perl   $wk_dir/00.bin/draw_fst_pi_v1.pl    $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.chr.diversity   ${Group_List[$i]}-${Group_List[$j]}    0.05

    mkdir  -p $wk_dir/05.Selected.ano/${Group_List[$i]}.VS.${Group_List[$j]}
    cd     $wk_dir/05.Selected.ano/${Group_List[$i]}.VS.${Group_List[$j]}

    cat    $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$j]}-vs-${Group_List[$i]}.0.05.${Group_List[$i]}.selected | grep -v CHROM |  awk '{print $1"\t"$2"\t"$3}' > $wk_dir/05.Selected.ano/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}.0.05.selected.bed 
    sed -i "s/chr/Cala/g"     ${Group_List[$i]}.0.05.selected.bed
    perl    $bed2vcf         ${Group_List[$i]}.0.05.selected.bed    $All_Sample_vcf    ${Group_List[$i]}.0.05.selected.vcf
    $iTools    Gfftools    AnoVar    -Var    ${Group_List[$i]}.0.05.selected.vcf  -Gff    $Ref_gff    -OutPut ./${Group_List[$i]}.0.05.selected.v1.anno.gz
    perl    $AnoChangFormat    ./${Group_List[$i]}.0.05.selected.v1.anno.gz    ./${Group_List[$i]}.0.05.selected.v2.anno


    cat    $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-vs-${Group_List[$j]}.0.05.${Group_List[$j]}.selected | grep -v CHROM |  awk '{print $1"\t"$2"\t"$3}' > $wk_dir/05.Selected.ano/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$j]}.0.05.selected.bed
    sed -i "s/chr/Cala/g"     ${Group_List[$j]}.0.05.selected.bed
    perl    $bed2vcf         ${Group_List[$j]}.0.05.selected.bed    $All_Sample_vcf    ${Group_List[$j]}.0.05.selected.vcf
    $iTools    Gfftools    AnoVar    -Var    ${Group_List[$j]}.0.05.selected.vcf  -Gff    $Ref_gff    -OutPut ./${Group_List[$j]}.0.05.selected.v1.anno.gz
    perl    $AnoChangFormat    ./${Group_List[$j]}.0.05.selected.v1.anno.gz    ./${Group_List[$j]}.0.05.selected.v2.anno


    done
done

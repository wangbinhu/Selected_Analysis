#!/bin/bash
#SBATCH -J selected.analysis  # fix:任务名
#SBATCH -p hfacexclu03,hfacexclu02    # 队列
#SBATCH -N 1            # 节点数
#SBATCH -n 8            # 进程数
#SBATCH -c 2            # 线程数
#SBATCH --mem=30g        # 内存，int
#SBATCH --time=6-00:00:00


# dir.and.file:
wk_dir=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/13.selected.analysis.v2.remove.sample7/
sc_dir=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/00.selected.analysis.bin/
Final_snp_vcf=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/03.gatk/02.gvcf.to.bed.gvcf/01.all.bed.chr/Final.final_snp.vcf.gz
Ref_gff=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/00.ref/Caln_genome.gff
# vim    $wk_dir/lib.name.group.table         # vim
Group_List=(CH DJK LZH MH QDH XKH);

# software:
source /public/home/bgiadmin/vcftools.sh;
vcftools=/public/home/bgiadmin/Software/08.ReqTools/vcftools/bin/vcftools
bcftools=/public/home/bgiadmin/Software/08.ReqTools/bcftools-1.9/bin/bcftools
python=/public/home/bgiadmin/anaconda3/envs/python3.8.5/bin/python
iTools=/public/home/bgiadmin/Software/08.ReqTools/iTools_Code/iTools
bgzip=/public/home/bgiadmin/Software/tabix-0.2.6/bgzip




# 00.mkdir: 
cd    $wk_dir
mkdir    -p    01.SubGroup  02.FST  03.Poly  04.Selected  05.Selected.ano     # mkdir  

# 01.SubGroup:
echo "#---- 01.SubGroup:"

cd       $wk_dir/01.SubGroup/
mv      ../lib.name.group.table     ./
$python    $sc_dir/01.SubGroup/split.to.list.py
# Filter all vcf:
$vcftools    --gzvcf    $Final_snp_vcf    --min-meanDP  2    --recode --recode-INFO-all  --maf 0.005    --max-missing 0.1    --out    ./All_Sample;
mv    ./All_Sample.recode.vcf    ./All_Sample.vcf;
$bgzip    ./All_Sample.vcf;
$bcftools    index    $wk_dir/01.SubGroup/All_Sample.vcf.gz;

# 02.FST:
echo "#---- 02.FST:"

cd      $wk_dir/02.FST/
Group_List_len=${#Group_List[@]};
for ((i=0;i<=(Group_List_len-1);i++))
do
    for((j=i+1;j<=(Group_List_len-1);j++))
    do
    $vcftools --gzvcf   $wk_dir/01.SubGroup/All_Sample.vcf.gz  --fst-window-size 10000 --weir-fst-pop  ../01.SubGroup/${Group_List[$i]}.list --weir-fst-pop   ../01.SubGroup/${Group_List[$j]}.list  --out   ./${Group_List[$i]}.VS.${Group_List[$j]}.fst;
    done
done

# 03.Poly:
echo "#---- 03.Poly:"

cd      $wk_dir/03.Poly/
for Breed in ${Group_List[@]};
do
    $bcftools    view    -S    ../01.SubGroup/$Breed.list   $wk_dir/01.SubGroup/All_Sample.vcf.gz    -Oz    -o    $Breed.vcf.gz;
    $bcftools    view  -m2 -M2     $Breed.vcf.gz    -Oz    -o    $Breed.diploid.vcf.gz;
    $vcftools    --gzvcf    $Breed.diploid.vcf.gz    --window-pi    10000    --out    ./$Breed.window10000;
done

# 04.Selected:
echo "#---- 04.Selected:"

cd  $wk_dir/04.Selected/
for ((i=0;i<=(Group_List_len-1);i++))
do
    for((j=i+1;j<=(Group_List_len-1);j++))
    do
    mkdir   -p    $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}
    cd      $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}
    perl    $sc_dir/00.bin/fst_pi_common.pl    $wk_dir/02.FST/${Group_List[$i]}.VS.${Group_List[$j]}.fst.windowed.weir.fst   $wk_dir/03.Poly//${Group_List[$i]}.window10000.windowed.pi    $wk_dir/03.Poly/${Group_List[$j]}.window10000.windowed.pi  0   | sort -k1,1 -k2,2n > $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.diversity
    cat     $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.diversity  | grep Cala > $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.chr.diversity
    sed     -i s/Cala/chr/g       $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.chr.diversity
    perl    $sc_dir/00.bin/draw_fst_pi_v1.pl    $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.chr.diversity   ${Group_List[$i]}-${Group_List[$j]}    0.05
    done
done

# 05.Selected.ano:
echo "#---- 05.Selected.ano:"

cd     $wk_dir/05.Selected.ano/
Group_List_len=${#Group_List[@]};
for ((i=0;i<=(Group_List_len-1);i++))
do
    for((j=i+1;j<=(Group_List_len-1);j++))
    do

    mkdir  -p $wk_dir/05.Selected.ano/${Group_List[$i]}.VS.${Group_List[$j]}
    cd     $wk_dir/05.Selected.ano/${Group_List[$i]}.VS.${Group_List[$j]}
    cat    $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$j]}-vs-${Group_List[$i]}.0.05.${Group_List[$i]}.selected | grep -v CHROM |  awk '{print $1"\t"$2"\t"$3}' > $wk_dir/05.Selected.ano/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}.0.05.selected.bed
    sed -i "s/chr/Cala/g"     ${Group_List[$i]}.0.05.selected.bed
    perl    $sc_dir/05.Selected.ano/bed2vcf.pl         ${Group_List[$i]}.0.05.selected.bed    $wk_dir/01.SubGroup/All_Sample.vcf.gz    ${Group_List[$i]}.0.05.selected.vcf
    $iTools    Gfftools    AnoVar    -Var    ${Group_List[$i]}.0.05.selected.vcf  -Gff    $Ref_gff    -OutPut ./${Group_List[$i]}.0.05.selected.v1.anno.gz
    perl    $sc_dir/05.Selected.ano/AnoChangFormat.pl    ./${Group_List[$i]}.0.05.selected.v1.anno.gz    ./${Group_List[$i]}.0.05.selected.v2.anno
    cat    $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-vs-${Group_List[$j]}.0.05.${Group_List[$j]}.selected | grep -v CHROM |  awk '{print $1"\t"$2"\t"$3}' > $wk_dir/05.Selected.ano/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$j]}.0.05.selected.bed
    sed -i "s/chr/Cala/g"     ${Group_List[$j]}.0.05.selected.bed
    perl    $sc_dir/05.Selected.ano/bed2vcf.pl         ${Group_List[$j]}.0.05.selected.bed    $wk_dir/01.SubGroup/All_Sample.vcf.gz    ${Group_List[$j]}.0.05.selected.vcf
    $iTools    Gfftools    AnoVar    -Var    ${Group_List[$j]}.0.05.selected.vcf  -Gff    $Ref_gff    -OutPut ./${Group_List[$j]}.0.05.selected.v1.anno.gz
    perl    $sc_dir/05.Selected.ano/AnoChangFormat.pl    ./${Group_List[$j]}.0.05.selected.v1.anno.gz    ./${Group_List[$j]}.0.05.selected.v2.anno

    done
done


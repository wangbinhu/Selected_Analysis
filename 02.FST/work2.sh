#!/bin/bash
#SBATCH -J 120.fst  # fix:任务名
#SBATCH -p hfacexclu03,hfacexclu02    # 队列
#SBATCH -N 1            # 节点数
#SBATCH -n 8            # 进程数
#SBATCH -c 1            # 线程数
#SBATCH --mem=30g        # 内存，int
#SBATCH --time=6-00:00:00
#SBATCH -o ./120.fst.%j.o      # fix:path
#SBATCH -e ./120.fst.%j.e      # fix:path

echo -e "Start Time: \c";  date;  START_TIME=$SECONDS;

All_Sample_vcf=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/09.selected.analysis/01.SubGroup/All_Sample.vcf.gz
Group_List=(CH DJK LZH MH QDH XKH);


source /public/home/bgiadmin/vcftools.sh;
vcftools='/public/home/bgiadmin/Software/08.ReqTools/vcftools/bin/vcftools'



Group_List_len=${#Group_List[@]};
for ((i=0;i<=(Group_List_len-1);i++))
do
    for((j=i+1;j<=(Group_List_len-1);j++))
    do
    $vcftools --gzvcf   $All_Sample_vcf  --fst-window-size 10000 --weir-fst-pop  ../01.SubGroup/${Group_List[$i]}.list --weir-fst-pop   ../01.SubGroup/${Group_List[$j]}.list  --out   ./${Group_List[$i]}.VS.${Group_List[$j]}.fst;
    done
done






echo -e "End   Time: \c";  date;  ELAPSED_TIME=$(($SECONDS - $START_TIME));  echo "$(($ELAPSED_TIME/3600)) h $((($ELAPSED_TIME/60)%60)) min $(($ELAPSED_TIME%60)) sec";


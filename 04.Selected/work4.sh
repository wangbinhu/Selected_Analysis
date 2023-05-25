
wk_dir=/public/home/bgiadmin/Project/F21FTSSCKF9402/ANIqxmyR/02.Analysis/120.ANIqxmyR.S120/09.selected.analysis/


Group_List=(CH DJK LZH MH QDH XKH);

Group_List_len=${#Group_List[@]};
for ((i=0;i<=(Group_List_len-1);i++))
do
    for((j=i+1;j<=(Group_List_len-1);j++))
    do

    mkdir  -p $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}
    cd     $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}
    
    perl   $wk_dir/00.bin/fst_pi_common.pl    $wk_dir/02.FST/${Group_List[$i]}.VS.${Group_List[$j]}.fst.windowed.weir.fst   $wk_dir/03.Poly//${Group_List[$i]}.window10000.windowed.pi    $wk_dir/03.Poly/${Group_List[$j]}.window10000.windowed.pi  0   | sort -k1,1 -k2,2n > $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.diversity
    cat     $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.diversity  | grep Cala > $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.chr.diversity 
    sed    -i s/Cala/chr/g       $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.chr.diversity 
    perl   $wk_dir/00.bin/draw_fst_pi_v1.pl    $wk_dir/04.Selected/${Group_List[$i]}.VS.${Group_List[$j]}/${Group_List[$i]}-${Group_List[$j]}.fst_pi.chr.diversity   ${Group_List[$i]}-${Group_List[$j]}    0.05


    done
done


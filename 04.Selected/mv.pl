use strict;
use v5.10;

my @name_list= qw(CH.VS.LZH  CH.VS.QDH  DJK.VS.LZH  DJK.VS.QDH LZH.VS.MH LZH.VS.XKH MH.VS.XKH CH.VS.DJK CH.VS.MH CH.VS.XKH DJK.VS.MH DJK.VS.XKH LZH.VS.QDH MH.VS.QDH QDH.VS.XKH);
# my @name_list= qw(ALF-C);
foreach my $name (@name_list)  {

    say $name;
    my ($first, $second) = split(/\.VS\./,$name);
    my $new_name = $second."-vs-".$first;
    say $new_name;
    system "mv ./04.selected.shell/$new_name.* ./$name/";
}


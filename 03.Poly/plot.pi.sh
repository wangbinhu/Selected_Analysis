Group_List=(CH DJK LZH MH QDH XKH);

Group_List_len=${#Group_List[@]};
for Breed in ${Group_List[@]};
do

cat $Breed.window10000.windowed.pi | grep Cala |  awk -F' '  '{print $1" "$2" "$3" "$5}' >  RectChr/$Breed	

done





# in.cofi ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

##################################### 全局参数 #######################################################

SetParaFor = global

File1  = ./CH
File2  = ./DJK
File3  = ./LZH
File4  = ./MH
File5  = ./QDH
File6  = ./XKH

InPut.file  ##  这个是必须输入参数，并且尽量放在最前,格式为[Chr Start End Value1 Value2 ... ValueN]
                       ##  其中用NA表示不画，chr End End NA不画但End可以用来贝记为chr的长度
ValueX = 6             ##  多少层，类同circos多少个圈，这不设默认是N,即根据File1的格式来的，可以自己设
#ChrSpacingRatio =0.2  ##  不同染色体chr之间的间隔比例(ChrWidth*ChrSpacingRatio)
Main = "PI Figure"  ##  the Fig Name  :MainRatioFontSize MainCor ShiftMainX  ShiftMainY
ColorsConf = col.file ##  通过在主配置文件 input 自定义颜色和 Value的对应关系;( P1 = "#FE0808" )
ChrArrayDirection = horizontal  ##  horizontal/vertical  chr是按纵排列还是横排列
##其它当很少用到的参数 BGChrEndCurve=1/ 等等
################################ Figure ############################################################

LabelUnit =cm


##############################     画布 和 图片 参数配置 #################################
#Chromosomes_order =   ## chr的顺序和只列某些chr出来画，若没有配置，程序会按chr名自动排序 chr1,chr2,chr3
#body=1200   ##   默认是1200，主画布大小设置  另外：up/down/left/right) = (55,25,100,120); #CanvasHeightRitao=1.0 CanvasWidthRitao=1.0
#RotatePng   = 0  ##  对Figure进行旋转的角度
#RotateChrName  = 0  ##  旋转chr名字 text
#ChrSpacingRatio=0.2    ##  不同染色体chr之间的间隔比例(Sum(ChrWidthX*X)*ChrSpacingRatio)




######    默认各层的配置参数 若各层没有配置的会，则会用这儿的参数 ######

SetParaFor = LevelALL  ##  下面是处理初始化参数 SetParaFor 参数处理,若为 LevelALL，即先为所有层设置的默认值

PType  = heatmap       ##  线，散点，直方图，热图,文本和共线性link, line, scatter/point, histogram ，link,LinkS heatmap(highlights)和text,PairWiseLink,heatmapAnimated/histAnimated,LinkS
#ShowColumn =          ##  若SetParaFor为LevelALL时，N层的ShowColumn默认为File1的第ValueN所的Column(N+3)
                       ##  参数格式可以设为 ShowColumn=File1:4 File2:4,5
                       ##  File1:4,5 表示file1的第四和第五列用heatmap表示
#crBegin="#006400"      ##  此层(ValueX)最低值Value 的配色
#crMid="#FFFF00"        ##  此层(ValueX)中间值Value 的配色
#crEnd="#FF0000"        ##  此层(ValueX)最大值Value 的配色
#crBG="#B8B8B8"         ##  此层(ValueX)背景色  的配色
#TopVHigh=0.95          ##  此层Top of ValueX 用最高点颜色[0.95],其它再等分  默认有可能是1.0/0.95
#TopVLow=0              ##  此层Top of ValueX 用最低点颜色[0],其它再等分
##YMax=                 ##  设置此层(ValueX)的最大值,默认自动   ## Cutoff   CrCutoff
##YMin=                 ##  设置此层(ValueX)的最小值,默认自动
Gradien=3             ##  此层(ValueX)多少等分颜色
#ChrWidth=20            ##  此层(ValueX)在画布的宽度
#BGWidthRatio =1        ##  此层(ValueX)的背景(backgroup)的宽度默认和ChrWidth一样(0-1])
#LogP=0                 ##  此层(ValueX)不作 0-log10(Value) 处理
ValueSpacingRatio=0.05    ##  同一染色体中此层(ValueX)之间的间隔比例(ChrWidth*ValueSpacingRatio)
#SizeGradienRatio=  ##设置渐变条的大小
ShowYaxis=1            ##  是否显示所有层的Y axis的起终点值,默认值此:0 不显示
NoShowGradien=1          ##  若要不显示渐变条  可设为1
########   更多配置的参数  可以自己设，没有的话会自动设置  #######

##Rotate/fill/Cutline/stroke-width/stroke//font-size/fontfamily/fill-opacity/strokeWidthBG/crStrokeBG/NoShowBackGroup   ### 等等
##ShiftGradienX=0 ## 渐变条左右移动   ##ShiftGradienY=0  ## 渐变条上下移动
ChrNameRatio=0.4

ShiftChrNameX=55
ShiftChrNameY=333   ## chrName移动  ChrNameRatio=1.0
#text-font-size   TextFontRatio=1.0




##################################### 各层的参数 #######################################################
###   具体某层的具体配置   把 DealLevePara  设为具体正数(<=ValueX),然后可以具体修改此层要改变的部分

SetParaFor=Level1
PType  = line
ChrWidth=100
ShowColumn = File1:4
BGChrEndCurve=0
#YMin=0
#YMax=15
#Cutline=4.18
LevelName="CH"
NameRotate=-90
crBegin=gold

SetParaFor=Level2
PType  = line
ChrWidth=100
ShowColumn = File2:4
BGChrEndCurve=0
#YMin=0
#YMax=15
#Cutline=4.18
LevelName="DJK "
NameRotate=-90
crBegin=green


SetParaFor=Level3
PType  = line
ChrWidth=100
BGChrEndCurve=0
ShowColumn = File3:4
#YMin=0
#YMax=50
#Cutline=4.18
LevelName="LZH"
NameRotate=-90
crBegin=blue


SetParaFor=Level4
PType  = line
ChrWidth=100
BGChrEndCurve=0
ShowColumn = File4:4
#YMin=0
#YMax=50
#Cutline=4.18
LevelName="MH"
NameRotate=-90
crBegin=orange

SetParaFor=Level5
PType  = line
ChrWidth=100
BGChrEndCurve=0
ShowColumn = File5:4
#YMin=0
#YMax=50
#Cutline=4.18
LevelName="QDH"
NameRotate=-90
crBegin=purple



SetParaFor=Level6
PType  = line
ChrWidth=100
BGChrEndCurve=0
ShowColumn = File6:4
#YMin=0
#YMax=50
#Cutline=4.18
LevelName="XKH"
NameRotate=-90
crBegin=brown


#crBegin="#006400"      ##  此层(ValueX)最低值Value 的配色
#crMid=
#crMid="#FFFF00"        ##  此层(ValueX)中间值Value 的配色
#crEnd="#FF0000"        ##  此层(ValueX)最大值Value 的配色

#SetParaFor=Level2    ##  下面开始处理第 2 层 参数处理
#File2    =            ##  可以输入别的文件 file1
#PType  = hist    ##  散点
#ShowColumn = File2:5 ##  把file1的第五列用散点图形式画出来)
##LevelName = "Name"  ##  the Level Name  :NameRatioFontSize NameCol ShiftNameX  ShiftNameY  NameRotate

#SetParaFor=Level3
#PType  = lines
#ShowColumn = File1:5,6
# in.cofi ------------------------------------------------------------------------------------------------------------------------------------------------------------------------



# col.file ------------------------------------------------------------------------------------------------------------------------------------------------------------------------


PH=gold
OIL=blue



# col.file ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

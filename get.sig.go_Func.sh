#!bin/bash


infile=$1



echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "$infile over-representation"
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
awk ' BEGIN {OFS=FS="\t"} {if ($9<0.05) {print $0, $9*19}} ' $infile
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "$infile under-representation"
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
awk ' BEGIN {FS="\t"} {if ($8<0.05) {print $0, $8*19}} ' $infile






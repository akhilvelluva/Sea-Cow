#!/bin/bash
######################This script will take names of Scaffolds/Chromosomes as input and Genotpe Using snpAD Tool
#***************************************Syntax to use******************##################
#############Please change the BAM file and Reference File name/location 
######################bash snpAD.sh input List********************
echo "Initializing the Script"
echo "Inspecting Input format"
inputfile=$1
inputfile >>List.txt
echo "Started Genotyping. It may take a while, please wait"
cat List.txt | while read r ; do Bam2snpAD -f Reference.fasta -i  Input.bam.bai -r $r  Input.bam; done > input.snpAD
echo "Genotyping Is finished"
echo "Run parameter estimation be aware that this steps can take very long" 
snpAD -c 48 -o priors.txt -O errors.txt input.snpAD > log.tab 2> log.err
echo "Producing VCF"
snpADCall -N Sample-Name -e errors.txt -p "`cat priors.txt`" input.snpAD > output.VCF
rm List.txt
echo "All Done"

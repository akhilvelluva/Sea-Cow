#!/usr/bin/python

import sys;


from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio.Alphabet import IUPAC


handle = open(sys.argv[1], "rU")
seq=[]

            
for record in SeqIO.parse(handle, "fasta") :
     seq.append(record.seq) #parse the fasta and get each sequnce

sequence1 = seq[0] # treat both sequences seppararely
sequence2= seq[1]


block=0
count=0
for a, b in zip(sequence1, sequence2):
     if block <50000:
          if str (a) != "N" and  str (b) != "N":
               block += 1
     else:
          block = 0
          block +=1
          count = 0
#     print block

     if str (a) != "N" and  str (b) != "N" and a != b and block < 50000:
          count +=1
#     print count
     if block == 50000:
          print block
          print count












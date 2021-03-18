#!/usr/bin/env python
#This python script match go ids from the exported file from Ensembl
#Need to make sure that Gene stable ID is common in both files
# coding: utf-8

# In[ ]:


#import necessary packages
import pandas as pd


# In[ ]:


#read the files
gtex = pd.read_table('mart_export_Ensembl_Go_Ids.txt', sep='\t') #################add database name
sys_id = pd.read_table('Input_Gene_name.txt', sep='\t') ########################add file name


# In[ ]:


#map the files
mapped=gtex.merge(sys_id, on='Gene stable ID')###########################on which column based grep


# In[ ]:


#write the output
mapped.to_csv('mapped_Go_Ids.txt', sep="\t") #################################output file name


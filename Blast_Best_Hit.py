#This programme is to grep best hit gene from blast tabular format out
#Using re module and itertools.groupby
import re
from itertools import groupby

with open('blast_table', 'r') as f_in:
    for v, g in groupby(f_in, lambda k: k.split()[0]):
        seen = set()
        for line in g:
            alpha = re.findall(r'^[a-zA-Z]+', line.split()[1])[0]
            if alpha not in seen:
                seen.add(alpha)
                print(line.strip())

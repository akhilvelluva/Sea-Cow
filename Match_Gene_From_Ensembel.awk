##This Script will compare the orthologuos ids with ensemble list
awk 'NR == FNR { if (!T[$2]) T[$2] = $1; next }
                        { lin = 0; for (i=1; i<=NF; i++)
                                if ($i in T) lin++ }
lin == NF               { for (i=1; i<=NF; i++) D[$i] = T[$i] }
END                     { for (i in D) print D[i] FS i }
' Ortho_Ids.txt ortho_ensemble_downloaded

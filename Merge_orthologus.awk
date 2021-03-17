##Script is for merging two orthologus list
##You may needed to run sort -k 2 before this 
join -j 2 Species01 Species02 | sort -k 2 | awk '
    BEGIN{getline; k=$1; f=$2" "$3}
        { while (f==$2" "$3){k=k" "$1; next} print f, k; f=$2" "$3; k=$1}
    END{print f, k}'

#!/bin/bash
for dir in */; do  
cd $dir
if compgen -G "output_*.txt" > /dev/null; then
    str="nt"
    substring="nt "
    strk="ksStatistic"
    for file in output_*.txt; do
        ksval1=$(grep "^$strk" $file | { grep -v grep || true; } | tail -n 1 | awk '{print $3}')
        ksval2=$(grep "^$strk" $file | { grep -v grep || true; } | head -n 1 | awk '{print $3}')
        if (( $(echo "$ksval1 > 0.002" | bc -l) )); then
            grep "^$str" $file | { grep -v grep || true; } | tail -n 1 | sed "s/$substring//g"
            grep "^$str" $file | { grep -v grep || true; } | tail -n 1 | sed "s/$substring//g" >> $TMPDIR/tempfileeeee.txt
        else
            if (( $(echo "$ksval2 > 0.002" | bc -l) )); then
                grep "^$str" $file | { grep -v grep || true; } | tail -n 1 | sed "s/$substring//g"
                grep "^$str" $file | { grep -v grep || true; } | tail -n 1 | sed "s/$substring//g" >> $TMPDIR/tempfileeeee.txt
            fi
        fi
    done
fi 
cd ..
done
cat $TMPDIR/tempfileeeee.txt | sort -n | head -n 1
rm $TMPDIR/tempfileeeee.txt
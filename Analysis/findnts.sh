#!/bin/bash
for dir in */; do  
cd $dir
if ! compgen -G "output_*.txt" > /dev/null; then
    echo “missing in ${dir}”
    str="nt"
    substring="nt "
    for file in live_output*.txt; do
        grep "^$str" $file | { grep -v grep || true; } | tail -n 1 | sed "s/$substring//g"
        grep "^$str" $file | { grep -v grep || true; } | tail -n 1 | sed "s/$substring//g" >> $TMPDIR/tempfileeeee.txt
    done
fi 
cd ..
done
cat $TMPDIR/tempfileeeee.txt | sort -n | head -n 1
rm $TMPDIR/tempfileeeee.txt

#!/bin/bash
#./metropolis.out parameters.txt outputfile verboseTF NFil N iSite baseSepDist Force dimerForce

cd /Users/katiebogue/MATLAB/GitHub/polymer-c/drivers

# polymer number of segments to sweep over
NumSeg=121


d=$(date +%Y.%d.%m.%M)

# output directory
output_dir=/Users/katiebogue/MATLAB/GitHub/polymer-c/verboseouts

# dimerization state
what='dimer' #'single' 'double'

mkdir $output_dir/${d}
# type of radius run

radtype=20

#occupied_opts=("25_42_63_104" "25" "42" "63" "104" "25_42" "25_63" "25_104" "25_42_63" "25_42_104" "25_63_104" "42_63" "42_63_104" "42_104" "63_104" "-1")
#numopts=16
#occupied_opts=("-1")

occupied_opts=("-1")
numopts=1

numopts=$((numopts - 1))

NFil=2       #2
#NumSeg=${i} #single=300; double=200; dimer=122
if [ ${NFil} -eq 2 ]; then
    baseSepDist=35.5
    #baseSepDist=${baseval}
else
    baseSepDist=0
fi
#dimerForce=0 #0
dimerForce=10
iSite='-1'
force=0
#


for i in $(seq 0 $numopts); do
    firstocc=${occupied_opts[$i]}
    for j in $(seq 0 $numopts); do
        secocc=${occupied_opts[$j]}
        occupiedtype=${firstocc}__${secocc}

        mkdir $output_dir/${d}/run_${occupiedtype}_${what}
    done
done

for i in $(seq 0 $numopts); do
    firstocc=${occupied_opts[$i]}
    for j in $(seq 0 $numopts); do
        secocc=${occupied_opts[$j]}
        occupiedtype=${firstocc}__${secocc}

        cd /Users/katiebogue/MATLAB/GitHub/polymer-c/src/PolymerCode
        printf "%s\n%s\n" "${firstocc//_/ }" "${secocc//_/ }" > bSites.txt

        #cat bSites.txt

        output_file="$output_dir/${d}/run_${occupiedtype}_${what}/output_${what}.N${NumSeg}.iSite${iSite}.BSD${baseSepDist}.force${force}.kdimer${dimerForce}.radtype${radtype}.occupied${occupiedtype}.txt"
        #output_file="outputtest.txt"
        cloutputfile="$output_dir/${d}/run_${occupiedtype}_${what}/out.txt"
        paramfile="parameters.txt"

        echo "$occupiedtype"
        #./metropolis.out "$paramfile" "$output_file" 1 "$NFil" "$NumSeg" "$iSite" "$baseSepDist" "$force" "$dimerForce" "$radtype"
        ./metropolis.out "$paramfile" "$output_file" 1 "$NFil" "$NumSeg" "$iSite" "$baseSepDist" "$force" "$dimerForce" "$radtype" > "$cloutputfile"

    done
done


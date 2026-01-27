#!/bin/bash
#./metropolis.out parameters.txt outputfile verboseTF NFil N iSite baseSepDist Force dimerForce

d=$(date +%Y.%d.%m_%H.%M.%S)
#d='2023.14.01'

# polymer number of segments to sweep over
NStart=1
NStop=600

# output directory
output_dir=/pub/kbogue1/GitHub/Data/polymer-c_data/largeactindimers

# dimerization state
what='double' #'single' 'double'

#for what in 'double' 'dimer';do
for what in 'dimer';do

  for baseval in 1 16.6667 35.5; do
    cd /pub/kbogue1/GitHub/polymer-c/drivers

    #Edit these parameters:
    NFil=2       #2
    #NumSeg=${i} #single=300; double=200; dimer=122
    if [ ${NFil} -eq 2 ]; then
        baseSepDist=${baseval}
    else
        baseSepDist=0
    fi
    if [ ${what} == 'double' ]; then
        dimerForce=0
    else
        dimerForce=10
    fi

      cp arrayslurm.sub submit.${what}.${d}.sub
      sed -i "24c\ ./metropolis.out parameters.txt output_${what}.N\${SLURM_ARRAY_TASK_ID}.iSite${iSite}.BSD${baseSepDist}.force${force}.kdimer${dimerForce}.txt 0 ${NFil} \$SLURM_ARRAY_TASK_ID -1 ${baseSepDist} 0 ${dimerForce}
    " "submit.${what}.${d}.sub"
      sed -i "3c\#SBATCH --job-name=${what}_${baseSepDist}_${d}      ## Name of the job.
    " "submit.${what}.${d}.sub"
      sed -i "14c\#SBATCH --array=${NStart}-${NStop}           ## number of array tasks. 
    " "submit.${what}.${d}.sub"
      sed -i "9c\#SBATCH --error=run.${what}.N%a_${d}/error_%A_%a.txt ## error log file; %A is job id, %a is array task id. 
    " "submit.${what}.${d}.sub"
    sed -i "10c\#SBATCH --output=run.${what}.N%a_${d}/out_%A_%a.txt  ## output filename. 
    " "submit.${what}.${d}.sub"
    sed -i "20c\cd run.${what}.N\${SLURM_ARRAY_TASK_ID}_${d} 
    " "submit.${what}.${d}.sub"


    cd $output_dir
    mkdir ${what}.${d}.FH2${baseSepDist}
    cd -
    cp submit.${what}.${d}.sub $output_dir/${what}.${d}.FH2${baseSepDist}/
    rm submit.${what}.${d}.sub

    for NumSeg in $(seq $NStart $NStop); do
      # read the hex string from file
      hex=$(<../src/PolymerCode/ISEED)

      # increment it: first interpret as hex (0x...), then add
      dec=$((16#$hex + 1))

      # convert back to lowercase hex and overwrite file
      printf "%x\n" "$dec" > ../src/PolymerCode/ISEED

      mkdir $output_dir/${what}.${d}.FH2${baseSepDist}/run.${what}.N${NumSeg}_${d}
      cp ../src/PolymerCode/metropolis.out ../src/PolymerCode/parameters.txt ../src/PolymerCode/ISEED $output_dir/${what}.${d}.FH2${baseSepDist}/run.${what}.N${NumSeg}_${d}
    done

    cd $output_dir/${what}.${d}.FH2${baseSepDist}
    sbatch submit.${what}.${d}.sub
  done
done


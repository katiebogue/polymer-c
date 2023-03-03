#!/bin/bash
#./metropolis.out parameters.txt outputfile verboseTF NFil N iSite baseSepDist Force dimerForce

d='TestLiveScript'
#d='2023.14.01'

# polymer number of segments to sweep over
NStart=122
NStop=122

# output directory
output_dir=/pub/kbogue1/GitHub/Data/polymer-c_data/

# dimerization state
what='dimer' #'single' 'double'

#Edit these parameters:
for NumSeg in $(seq $NStart $NStop); do
  NFil=2       #2
  #NumSeg=${i} #single=300; double=200; dimer=122
  if [ ${NFil} -eq 2 ]; then
    baseSepDist=16.667000
  else
    baseSepDist=0
  fi
  dimerForce=10 #0
  iSite='-1'
  force=0
  #

  #echo submit.${what}.N${NumSeg}.${d}.sh

  cp testslurm.sub submit.${what}.N${NumSeg}.${d}.sub
  sed -i "23c\ ./metropolistest.out parameters.txt output_${what}.N${NumSeg}.iSite${iSite}.BSD${baseSepDist}.force${force}.kdimer${dimerForce}.txt 0 ${NFil} ${NumSeg} ${iSite} ${baseSepDist} ${force} ${dimerForce}
" "submit.${what}.N${NumSeg}.${d}.sub"
  sed -i "3c\#SBATCH --job-name=${what}_${NumSeg}      ## Name of the job.
" "submit.${what}.N${NumSeg}.${d}.sub"
done

cd $output_dir
mkdir ${what}.${d}
cd -

for NumSeg in $(seq $NStart $NStop); do
  mkdir $output_dir/${what}.${d}/run.${what}.N${NumSeg}_${d}
  cp ../src/PolymerCode/metropolistest.out ../src/PolymerCode/parameters.txt ../src/PolymerCode/ISEED $output_dir/${what}.${d}/run.${what}.N${NumSeg}_${d}
  cp submit.${what}.N${NumSeg}.${d}.sub $output_dir/${what}.${d}/run.${what}.N${NumSeg}_${d}
  rm submit.${what}.N${NumSeg}.${d}.sub
done

for NumSeg in $(seq $NStart $NStop); do
  cd $output_dir/${what}.${d}/run.${what}.N${NumSeg}_${d}
  sbatch submit.${what}.N${NumSeg}.${d}.sub
done
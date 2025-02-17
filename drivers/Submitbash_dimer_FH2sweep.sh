#!/bin/bash
#./metropolis.out parameters.txt outputfile verboseTF NFil N iSite baseSepDist Force dimerForce

for baseval in $(seq 0 0); do

  cd /pub/kbogue1/GitHub/polymer-c/drivers

  d=$(date +%Y.%d.%m.%H.%M)
  #d=$(date +%Y.%d).${baseval}
  #d='2023.14.01'

  # polymer number of segments to sweep over
  NStart=1
  NStop=400

  # output directory
  output_dir=/pub/kbogue1/GitHub/Data/polymer-c_data/FH2_0

  # dimerization state
  what='dimer' #'single' 'double'

  mkdir $output_dir/${what}.${d}
  # type of radius run
  for radtype in 20; do
    cd /pub/kbogue1/GitHub/polymer-c/drivers

    #Edit these parameters:
    for NumSeg in $(seq $NStart $NStop); do
      NFil=2       #2
      #NumSeg=${i} #single=300; double=200; dimer=122
      if [ ${NFil} -eq 2 ]; then
        #baseSepDist=35.5
        baseSepDist=${baseval}
      else
        baseSepDist=0
      fi
      dimerForce=10 #0
      #dimerForce=0
      iSite='-1'
      force=0
      #

      #echo submit.${what}.N${NumSeg}.${d}.sh

      cp testslurm.sub submit.${what}.N${NumSeg}.${d}.sub
      sed -i "23c\ ./metropolis.out parameters.txt output_${what}.N${NumSeg}.iSite${iSite}.BSD${baseSepDist}.force${force}.kdimer${dimerForce}.radtype${radtype}.txt 0 ${NFil} ${NumSeg} ${iSite} ${baseSepDist} ${force} ${dimerForce} ${radtype}
    " "submit.${what}.N${NumSeg}.${d}.sub"
      sed -i "3c\#SBATCH --job-name=${what}_${NumSeg}      ## Name of the job.
    " "submit.${what}.N${NumSeg}.${d}.sub"
    done

    cd $output_dir
    #mkdir ${what}.${d}
    mkdir ${what}.${d}
    cd -

    for NumSeg in $(seq $NStart $NStop); do
      mkdir $output_dir/${what}.${d}/run.${what}.N${NumSeg}_${d}
      cp ../src/PolymerCode/metropolis.out ../src/PolymerCode/parameters.txt ../src/PolymerCode/ISEED $output_dir/${what}.${d}/run.${what}.N${NumSeg}_${d}
      cp submit.${what}.N${NumSeg}.${d}.sub $output_dir/${what}.${d}/run.${what}.N${NumSeg}_${d}
      rm submit.${what}.N${NumSeg}.${d}.sub
    done

    for NumSeg in $(seq $NStart $NStop); do
      cd $output_dir/${what}.${d}/run.${what}.N${NumSeg}_${d}
      sbatch submit.${what}.N${NumSeg}.${d}.sub
    done

  done

done
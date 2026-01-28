#!/bin/bash

cd /pub/kbogue1/GitHub/polymer-c/Gillespie/ForminProject/GridSearch/drivers

folder=/dfs6/pub/kbogue1/GitHub/Data/Gillespie_data/HPC3outputs/GridSearch.2025.31.03.10.01
folder=/dfs6/pub/kbogue1/GitHub/Data/Gillespie_data/HPC3outputs/GridSearch.2026.27.01.11.18
for d in $folder/i_*
do
    cd $d
    rm error_*.txt
    rm out_*.txt
    sbatch runGrid.sub
done

#!/bin/bash
#SBATCH --job-name="2NOAGGDIST"
#SBATCH --partition=shared
#SBATCH --nodes=1
#SBATCH -t 48:00:00
#SBATCH --mem=72G
#SBATCH --ntasks-per-node=36
#SBATCH --account=uot138

rep=2
for i in 10; 
do
	mkdir 30_marker_genes/${i}
	cp ../../hyperbolic_exp_build_tree.multi/30_marker_genes/${i}/comb.txt 30_marker_genes/${i}
	while IFS= read -r line
	do
       		bash scripts/prepare_comb_not_agg_dist.sh ${line} ${rep} ${i}; 
	done < 30_marker_genes/${i}/comb.txt
done

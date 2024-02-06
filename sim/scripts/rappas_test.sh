#!/bin/bash
#SBATCH --job-name="TEST"
#SBATCH --partition=shared
#SBATCH --nodes=1
#SBATCH -t 48:00:00
#SBATCH --mem=18G
#SBATCH --ntasks-per-node=9
#SBATCH --account=uot138

for i in {1..5};
do
	rappas -p p -d rappas_output_${i}/DB_session_k8_o1.5.union -q placement/00${i}/query.fa
	gappa examine graft --jplace-path placements_query.fa.jplace --out-dir rappas_output_${i}/ --allow-file-overwriting
	bash ~/evaluate_placement.sh placement/00${i}/tree.nwk rappas_output_${i}/placements_query.fa.newick placement/00${i}/query.fa placement/00${i}/backbone.nwk > rappas_output_${i}/error.txt
done

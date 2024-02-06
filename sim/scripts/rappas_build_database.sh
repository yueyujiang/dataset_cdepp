#!/bin/bash
#SBATCH --job-name="rappas"
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH -t 48:00:00
#SBATCH --mem=249325M
#SBATCH --ntasks-per-node=128
#SBATCH --account=uot138

for i in 5;
do
	mkdir rappas_output_${i}/
	/usr/bin/time -v rappas -b ~/miniconda3/bin/raxml-ng -s nucl -w rappas_output_${i}/ -r placement/00${i}/backbone.fa -t placement/00${i}/scampp_epa_results/run.raxml.bestTree -p b --use_unrooted > rappas_output_${i}/out.log 2> rappas_output_${i}/out.err
done

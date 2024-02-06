#!/bin/bash
#SBATCH --job-name="GET_ERROR"
#SBATCH --partition=shared
#SBATCH --nodes=1
#SBATCH -t 48:00:00
#SBATCH --mem=32G
#SBATCH --ntasks-per-node=16
#SBATCH --account=uot138
# $1 outdir
# $2 gene
echo rep ${2}
mkdir ${2}/jc_result
nw_topology ${2}/backbone.nwk > ${2}/backbone.topo.tree
raxml-ng --evaluate --msa ${2}/backbone_onecopy.fa --model JC --tree ${2}/backbone.topo.tree --brlen scaled --threads 1 --prefix ${2}/jc_result/run --redo --force
run_apples.py -s ${2}/backbone_onecopy.fa -q ${2}/query.fa -t ${2}/jc_result/run.raxml.bestTree -f 0 -b 5 -o ${2}/${1}/jc_result.jplace -D
gappa examine graft --jplace-path ${2}/${1}/jc_result.jplace --out-dir ${2}/${1}/ --allow-file-overwriting
bash ~/evaluate_placement.sh wol.nwk ${2}/${1}/jc_result.newick ${2}/query.fa ${2}/backbone.nwk > ${2}/${1}/error.new.txt

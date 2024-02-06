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
mkdir ${2}/epa_result
nw_topology ${2}/backbone.nwk > ${2}/backbone.topo.tree
raxml-ng --evaluate --msa ${2}/backbone_onecopy.fa --model GTR+F+G --tree ${2}/backbone.topo.tree --brlen scaled --threads 1 --prefix ${2}/epa_result/run --redo --force
epa-ng --ref-msa ${2}/backbone_onecopy.fa --tree ${2}/epa_result/run.raxml.bestTree --query ${2}/query.fa --model ${2}/epa_result/run.raxml.bestModel -w ${2}/epa_result/  --redo > ${2}/epa_result/epa-ng.log 2> ${2}/epa_result/epa-ng.err
gappa examine graft --jplace-path ${2}/${1}/epa_result.jplace --out-dir ${2}/${1}/ --allow-file-overwriting
bash ~/evaluate_placement.sh wol.nwk ${2}/${1}/epa_result.newick ${2}/query.fa ${2}/backbone.nwk > ${2}/${1}/error.new.txt

# $1 gene

#source activate cluster_depp
rm -rf placement/${1}/jc_results
mkdir placement/${1}/jc_results
nw_topology placement/${1}/backbone.nwk > placement/${1}/backbone.topo.nwk
raxml-ng -evaluate -msa placement/${1}/backbone.fa --tree placement/${1}/backbone.topo.nwk --model JC -blopt nr_safe --prefix placement/${1}/jc_results/run --force
run_apples.py -q placement/${1}/query.fa -s placement/${1}/backbone.fa -t placement/${1}/jc_results/run.raxml.bestTree -o placement/${1}/jc_results/placement.jplace -f 0 -b 5 -D
gappa examine graft --jplace-path placement/${1}/jc_results/placement.jplace --out-dir placement/${1}/jc_results/ --allow-file-overwriting
bash ~/evaluate_placement.sh placement/${1}/tree.nwk placement/${1}/jc_results/placement.newick placement/${1}/query.fa placement/${1}/backbone.nwk > placement/${1}/jc_results/error.txt

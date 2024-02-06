# $1 gene

#rm -rf placement/${1}/scampp_epa_results
#mkdir placement/${1}/scampp_epa_results
#nw_topology placement/${1}/backbone.nwk > placement/${1}/backbone.topo.nwk
#raxml-ng --evaluate --msa placement/${1}/backbone.fa --model GTR+F+G --tree placement/${1}/backbone.topo.nwk --brlen scaled --threads 1 --prefix placement/${1}/scampp_epa_results/run --redo --force
#python ~/software/PLUSplacer-taxtastic/EPA-ng-SCAMPP.py -i placement/${1}/scampp_epa_results/run.raxml.bestModel -t placement/${1}/scampp_epa_results/run.raxml.bestTree -a placement/${1}/backbone.fa -d placement/${1}/scampp_epa_results -o placement -q placement/${1}/query.fa -n $RANDOM
python scripts/swap_jplace.py --infile placement/${1}/scampp_epa_results/placement.jplace --outfile placement/${1}/scampp_epa_results/placement_swap.jplace
python ~/tool/jplace_to_newick.py --infile placement/${1}/scampp_epa_results/placement_swap.jplace --outfile placement/${1}/scampp_epa_results/placement.newick
#gappa examine graft --jplace-path placement/${1}/scampp_epa_results/placement.jplace --out-dir placement/${1}/scampp_epa_results/ --allow-file-overwriting
bash ~/evaluate_placement.sh placement/${1}/tree.nwk placement/${1}/scampp_epa_results/placement.newick placement/${1}/query.fa placement/${1}/backbone.nwk > placement/${1}/scampp_epa_results/error.txt

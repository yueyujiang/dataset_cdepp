# $1 gene

source activate cluster_depp
rm -rf placement/${1}/depp_results_subtree
depp_distance.py seqdir=placement/${1}/test_seqs_add_repr query_seq_file=placement/${1}/query.fa model_path=placement/${1}/model_placement_add_repr_multi/cluster-depp.pth outdir=placement/${1}/depp_results_subtree use_multi_class=True prob_thr=200
for dist in placement/${1}/depp_results_subtree/depp*csv;
do
	i=`basename ${dist}`
	i=${i%.*}
	i=`echo ${i} | sed "s/depp//g"`
	run_apples.py -d ${dist} -t placement/${1}/backbone.nwk -o placement/${1}/depp_results_subtree/placement${i}.jplace -f 0 -b 5
done

python ~/tool/combine_json.py --indir placement/${1}/depp_results_subtree --outfile placement/${1}/depp_results_subtree/placement.jplace
gappa examine graft --jplace-path placement/${1}/depp_results_subtree/placement.jplace --out-dir placement/${1}/depp_results_subtree/ --allow-file-overwriting
bash ~/evaluate_placement.sh placement/${1}/tree.nwk placement/${1}/depp_results_subtree/placement.newick placement/${1}/query.fa placement/${1}/backbone.nwk > placement/${1}/depp_results_subtree/error.txt

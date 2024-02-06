# $1 gene

source activate cluster_depp
rm -rf ${1}/cluster_depp_result_subtree
#rm ${1}/cluster_depp_result_subtree/cluster_depp_result_subtree.jplace
depp_distance.py seqdir=${1}/test_seqs_add_repr query_seq_file=${1}/query.fa model_path=${1}/model_add_repr_multi/cluster-depp.pth outdir=${1}/cluster_depp_result_subtree use_multi_class=True prob_thr=200
for dist in ${1}/cluster_depp_result_subtree/depp*csv;
do
	i=`basename ${dist}`
	i=${i%.*}
	echo ${dist}
	run_apples.py -d ${dist} -t ${1}/backbone.nwk -f 0 -b 5 -o ${1}/cluster_depp_result_subtree/placement${i}.jplace
done

python ~/tool/combine_json.py --indir ${1}/cluster_depp_result_subtree --outfile ${1}/cluster_depp_result_subtree/cluster_depp_result_subtree.jplace
gappa examine graft --jplace-path ${1}/cluster_depp_result_subtree/cluster_depp_result_subtree.jplace --out-dir ${1}/cluster_depp_result_subtree --allow-file-overwriting
bash ~/evaluate_placement.sh wol.nwk ${1}/cluster_depp_result_subtree/cluster_depp_result_subtree.newick ${1}/query.fa ${1}/backbone.nwk > ${1}/cluster_depp_result_subtree/error.new.txt

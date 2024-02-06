# $1 comb
# $2 rep
# $3 num gene

i=${3}
rep=${2}
new_dir=30_marker_genes/${i}/`echo ${1} | sed "s/,/_/g"`_not_agg_dist
#rm -rf ${new_dir} ${new_dir}/rep${rep}/subtrees.trees
mkdir -p ${new_dir}/rep${rep}
cat backbone${2}_blone.nwk > ${new_dir}/rep${rep}/subtrees.trees
IFS=',' read -r -a genes <<< "${1}"
for gene in "${genes[@]}";
do
	echo "processing gene" ${gene}
	echo "get probability"
	source activate cluster_depp
	depp_distance.py seqdir=30_marker_genes/${gene}/rep${rep}/test_seqs/ query_seq_file=30_marker_genes/${gene}/query${rep}.fa model_path=30_marker_genes/${gene}/model${rep}_add_repr/cluster-depp.pth outdir=${new_dir}/rep${rep}/ only_class=True
	mkdir ${new_dir}/rep${rep}/${gene}
	mkdir ${new_dir}/rep${rep}/${gene}/backbone_seq
	python scripts/assign_query_cluster_not_agg_dist.py --prob ${new_dir}/rep${rep}/class_prob.pt --names ${new_dir}/rep${rep}/query_seq_names.pt --outdir ${new_dir}/rep${rep}/${gene}/assigned_cluster
	echo "get distance matrices"
	for c in {0..7};
	do
		echo "processing cluster" ${c}
		cat ${new_dir}/rep${rep}/${gene}/assigned_cluster/*/${c}.txt > ${new_dir}/rep${rep}/${gene}/assigned_cluster/${c}.txt
		python ~/tool/grep_seq.py --infile 30_marker_genes/${gene}/query${rep}.fa --outfile ${new_dir}/rep${rep}/query${c}.fa --seqnames ${new_dir}/rep${rep}/${gene}/assigned_cluster/${c}.txt
		cat ${new_dir}/rep${rep}/query${c}.fa 30_marker_genes/${gene}/rep${rep}/test_seqs_add_repr/${c}.fa > ${new_dir}/rep${rep}/${gene}/backbone_seq/${c}.fa
		source activate cluster_depp
		depp_distance.py seqdir=${new_dir}/rep${rep}/${gene}/backbone_seq query_seq_file=${new_dir}/rep${rep}/query${c}.fa model_path=30_marker_genes/${gene}/model${rep}_add_repr/cluster-depp.pth outdir=${new_dir}/rep${rep}/${gene} use_cluster=${c}
		#python ~/tool/get_tree_dist.py --treefile 30_marker_genes/${gene}/rep${rep}/test_trees_add_repr/${c}.nwk --outfile 30_marker_genes/${gene}/rep${rep}/build_tree/backbone${c}.csv
                python ~/tool/extend_csv.py --infile2 30_marker_genes/${gene}/rep${rep}/build_tree/backbone${c}.csv --infile1 ${new_dir}/rep${rep}/${gene}/depp${c}.csv --outfile ${new_dir}/rep${rep}/${gene}/depp${c}_addtreedist.csv
                python ~/tool/csv_to_phylip.py --infile ${new_dir}/rep${rep}/${gene}/depp${c}_addtreedist.csv --outfile ${new_dir}/rep${rep}/${gene}/depp${c}_addtreedist.phylip
		conda deactivate
		fastme -i ${new_dir}/rep${rep}/${gene}/depp${c}_addtreedist.phylip -o ${new_dir}/rep${rep}/${gene}/subtree${c}.nwk --nni -s -m B --output_info=${new_dir}/rep${rep}/${gene}/subtree${c}.log
		cat ${new_dir}/rep${rep}/${gene}/subtree${c}.nwk >> ${new_dir}/rep${rep}/subtrees.trees
		tree_tmp=${new_dir}/rep${rep}/${gene}/subtree${c}.nwk
		# repeat tree with high probability
		for t in {0..1};
		do
			if test -f "${new_dir}/rep${rep}/${gene}/assigned_cluster/${t}/${c}.txt";
			then
				nw_prune -f ${tree_tmp} ${new_dir}/rep${rep}/${gene}/assigned_cluster/${t}/${c}.txt > ${new_dir}/rep${rep}/${gene}/subtree${c}_rmthr${t}.nwk
				tree_tmp=${new_dir}/rep${rep}/${gene}/subtree${c}_rmthr${t}.nwk
			fi
			cat ${tree_tmp} >> ${new_dir}/rep${rep}/subtrees.trees
		done
		rm ${new_dir}/rep${rep}/query${c}.fa ${new_dir}/rep${rep}/${gene}/depp${c}.csv
	done
	rm -rf ${new_dir}/rep${rep}/${gene}/backbone_seq
done
conda deactivate
sed -i '/^$/d' ${new_dir}/rep${rep}/subtrees.trees
java -jar ~/software/astral.5.6.9/Astral/astral.5.6.9.jar -i ${new_dir}/rep${rep}/subtrees.trees -j backbone${2}_blone.nwk -o ${new_dir}/rep${rep}/out.tree 2> ${new_dir}/rep${rep}/astral.log

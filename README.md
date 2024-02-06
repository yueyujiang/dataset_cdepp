# Dataset for Scaling deep phylogenetic placement to ultra-large reference trees: a tree-aware ensemble approach

## Software
The software is available in PyPi and can be installed using `pip install depp-test`

## Data description

### dataset\_cdepp/WoL/Placement

*   commands.txt: commands to run the experiments in the paper for placement using WoL data
*   scripts:
    *   scripts/test_cluster_depp.rand.subtree.sh: script for running C-DEPP
    *   scripts/test_epa.rand.sh: script for running EPA-ng
    *   scripts/test_jc.rand.sh: script for running APPLES2
*   p[gene_id] (10 genes in total):
    *   p[gene_id]/backbone.fa: backbone sequences
    *   p[gene_id]/query.fa: query sequences
    *   p[gene_id]/tree.nwk: phylogenetic trees including backbone and query species

### dataset\_cdepp/WoL/Build\_tree

*   commands.txt: commands to run the experiments in the paper for extending trees using WoL data
*   scripts:
    *   scripts/assign_query_cluster_not_agg_dist.py: script for assigning queries to clusters
    *   scripts/prepare_comb_not_agg_dist.sh: script for extending tree using C-DEPP
    *   scripts/prepare_comb_build_tree_job_not_agg_dist_rep[rep_id].sh: script for running scripts/prepare_comb_not_agg_dist.sh in the rep[rep_id] data. `rep_id` is 1 or 2.
*   comb_[gene_num].txt: the genes we randomly selected for extending the tree. `gene_num` is the number of genes we are using.
*   rep[rep_id]_query.label: the query species we selected in the experiments. `rep_id` is 1 or 2.

### dataset\_cdepp/WoL/sim

*   commands.txt: commands to run the experiments in the paper for placement using Simulated data.
*   scripts:
    *   scripts/test_placement_subtree.sh: script for running C-DEPP
    *   scripts/test_scampp_epa.sh: script for running SCAMPP EPA-NG
    *   scripts/test_jc.sh: script for running APPLES2
    *   scripts/rappas_build_database.sh: script for building database for running RAPPAS
    *   scripts/rappas_test.sh: script for running RAPPAS
*   00[gene_id] (`gene_id` range from 1 to 5):
    *   00[gene_id]/backbone.fa: backbone sequences
    *   00[gene_id]/query.fa: query sequences
    *   00[gene_id]/tree.nwk: phylogenetic trees including backbone and query species


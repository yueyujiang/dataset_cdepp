import argparse
import json
import torch
import os
import numpy as np

parser = argparse.ArgumentParser(description='test')
parser.add_argument('--prob', type=str)
parser.add_argument('--names', type=str)
parser.add_argument('--outdir', type=str)
args = parser.parse_args()

prob = torch.load(args.prob)
species = torch.load(args.names)
#prob, prob_idx = torch.sort(prob, dim=-1)
prob_idx = torch.arange(prob.shape[-1]).unsqueeze(0).repeat(prob.shape[0], 1)

for c1 in range(prob.shape[-1]): # loop over cluster for output file
    thrs = [0.1, 0.5, 0.8, 1]
    for i, thr in enumerate(thrs[:-1]):
        thr2 = thrs[i+1]
        valid = (prob[:, c1] <= thr2) & (prob[:, c1] > thr)
        valid_species = np.array(species)[valid]
        if len(valid_species) == 0:
            continue
        os.makedirs(f"{args.outdir}/{i}", exist_ok=True)
        with open(f"{args.outdir}/{i}/{c1}.txt", 'w') as f:
            f.write("\n".join(valid_species)+"\n")

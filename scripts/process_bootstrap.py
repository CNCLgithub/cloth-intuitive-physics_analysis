import os, json
import pandas as pd
import numpy as np
from os.path import join as opj

'''
Generate :
data/parsed_questions_bootstrap/acc_each_scene_stiff.csv
data/parsed_questions_bootstrap/cor_each_scene_stiff.csv
data/parsed_questions_bootstrap/cor_stiff.csv


Before running this script, ensure you've executed bash data/parsed_questions_bootstrap/download_bootstrap_data.sh.
Keep in mind that it could be time-consuming since the data is approximately 110GB in size.
'''

cond = 'stiff'  # stiff | mass

cur_dir = os.getcwd()
parent_dir = os.path.dirname(cur_dir)
bootstrap_dir = opj(parent_dir, 'data', 'parsed_questions_bootstrap')

in_f = opj(bootstrap_dir, cond, f'parsed_questions_{cond}_%s.csv')
out_dir = bootstrap_dir
iters = 1000

############### Exclude each scene acc: acc_each_scene_stiff.csv ########
out_f = opj(out_dir, f'acc_each_scene_{cond}.csv')

bootstrap_df = pd.DataFrame()
for i in range(iters):
    if i % 50 == 0:
        print(f'{i}/{iters}')
    _in_f = pd.read_csv(in_f % i)
    
    df = _in_f.groupby(['exclude_scene']).agg({
        'woven_acc': 'mean',
        'human_acc': 'mean',
        'dnn_acc': 'mean',
        'dnn2_acc': 'mean',
        'wovenab_acc': 'mean',
        'wovenab2_acc': 'mean'
    }).reset_index()
    df['iter'] = i
    
    bootstrap_df = pd.concat([bootstrap_df, df], ignore_index=True)
    
bootstrap_df.to_csv(out_f, index=False)
print(f"Saved: \n {out_f}")


############### Exclude each scene cor: cor_each_scene_stiff.csv ########
def get_cor(x):
    data = [
        np.corrcoef(x['woven_acc'], x['human_acc'])[0][1],
        np.corrcoef(x['dnn_acc'], x['human_acc'])[0][1],
        np.corrcoef(x['dnn2_acc'], x['human_acc'])[0][1],
        np.corrcoef(x['wovenab_acc'], x['human_acc'])[0][1],
        np.corrcoef(x['wovenab2_acc'], x['human_acc'])[0][1],
        ]
    return data

out_f = opj(out_dir, f'cor_each_scene_{cond}.csv')

bootstrap_df = pd.DataFrame()
for i in range(iters):
    if i % 50 == 0:
        print(f'{i}/{iters}')
    _in_f = in_f % i
    _in_f = pd.read_csv(_in_f)
    
    _in_f = _in_f.groupby(['reldiff', 'ireldiff', 'exclude_scene']).agg({
        'woven_acc': 'mean',
        'human_acc': 'mean',
        'dnn_acc': 'mean',
        'dnn2_acc': 'mean',
        'wovenab_acc': 'mean',
        'wovenab2_acc': 'mean'
    }).reset_index()

    df = _in_f.groupby(['exclude_scene']).apply(get_cor).reset_index()
    df[['cor_woven', 'cor_dnn', 'cor_dnn2', 'cor_wovenab', 'cor_wovenab2']] = pd.DataFrame(df[0].tolist(), index=df.index)
    df = df.drop(columns=[0])
    bootstrap_df = pd.concat([bootstrap_df, df], ignore_index=True)
    
bootstrap_df.to_csv(out_f, index=False)
print(f"Saved: \n {out_f}")



################ All Correlation: cor_mass.csv ###################
out_f = opj(out_dir, f'cor_{cond}.csv')

data_list = []

for i in range(iters):
    if i % 50 == 0:
        print(f'{i}/{iters}')
    _in_f = pd.read_csv(in_f % i)

    df = _in_f.groupby(['reldiff', 'ireldiff']).agg({
        'woven_acc': 'mean',
        'human_acc': 'mean',
        'dnn_acc': 'mean',
        'dnn2_acc': 'mean',
        'wovenab_acc': 'mean',
        'wovenab2_acc': 'mean'
    }).reset_index()
        
    data = {
        'cor_woven': np.corrcoef(df['woven_acc'], df['human_acc'])[0][1],
        'cor_dnn': np.corrcoef(df['dnn_acc'], df['human_acc'])[0][1],
        'cor_dnn2': np.corrcoef(df['dnn2_acc'], df['human_acc'])[0][1],
        'cor_wovenab': np.corrcoef(df['wovenab_acc'], df['human_acc'])[0][1],
        'cor_wovenab2': np.corrcoef(df['wovenab2_acc'], df['human_acc'])[0][1],
    }
    data_list.append(data)

bootstrap_df = pd.DataFrame(data_list)

bootstrap_df.to_csv(out_f, index=False)
print(f"Saved: \n{out_f}")


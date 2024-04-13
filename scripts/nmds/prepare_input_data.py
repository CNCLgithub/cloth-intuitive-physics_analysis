import pandas as pd
from os.path import join as opj
import os

all_conds = ['stiff', 'mass']
all_models = ['human', 'dnn', 'woven', 'wovenab','wovenab2', 'dnn2']
input_dir = '../../data'

cur_dir = os.getcwd()

for cond in all_conds:
    out_dir = opj(cur_dir, 'data', 'data_'+cond)
    os.makedirs(out_dir, exist_ok=True)
    
    input_csv = opj(input_dir, f'parsed_questions_{cond}.csv')
    with open(input_csv, 'r') as f:
        df = pd.read_csv(f)
        f.close()
    
    for model in all_models:
        df['Res'] = df[f'{model}_res']
        out_l, out_m, out_r = [], [], []
        for index, row in df.iterrows():
            out_m.append("{}_{}_{}".format(row['scene_mid'], row['m_mid'], row['stiff_mid']))
            if row.Res == 1:
                out_l.append("{}_{}_{}".format(row['scene_left'], row['m_left'], row['stiff_left']))
                out_r.append("{}_{}_{}".format(row['scene_right'], row['m_right'], row['stiff_right']))
            elif row.Res == -1:
                out_r.append("{}_{}_{}".format(row['scene_left'], row['m_left'], row['stiff_left']))
                out_l.append("{}_{}_{}".format(row['scene_right'], row['m_right'], row['stiff_right']))     
        
        out_data = pd.DataFrame(columns = ['l'])
        out_data['l'] = out_l
        out_data['m'] = out_m
        out_data['r'] = out_r
        out_data['e'] = out_m
        out_f = opj(out_dir, 'nmds_{}.csv'.format(model))
        out_data.to_csv(out_f, index=False)
        print("@@@ Saved: {}".format(out_f))
import pandas as pd
import matplotlib.pyplot as plt
import glob
import os

input_directory = result_path + 'system'
graph_directory = garph_path  + 'system' 

def make_csv(numa) : 
    csv_files = glob.glob(os.path.join(input_directory, numa + '_*.csv'))
    data_dict = {}

    for csv_file in csv_files:
        channel = os.path.splitext(os.path.basename(csv_file))[0].split('_')[2]
        
        df = pd.read_csv(csv_file, header=None, names=['r:w', 'bandwidth(GB/s)', 'latency(ns)'])
        df['channel'] = channel

        for r_w_value, group_df in df.groupby('r:w'):
            if r_w_value == "r:w" :
                continue
            if r_w_value not in data_dict:
                data_dict[r_w_value] = []
            group_df = group_df.drop(columns=['r:w'])
            data_dict[r_w_value].append(group_df)

    for r_w_value, dfs in data_dict.items():
        combined_df = pd.concat(dfs)
        output_file = input_directory + f'/{numa}_read_write_{r_w_value}.csv'
        combined_df.to_csv(output_file, index=False, header=['bandwidth(GB/s)', 'latency(ns)','channel'])
        
        graph_file = graph_directory + f'/{numa}_read_write_{r_w_value}.png'

        df = pd.read_csv(output_file)
        
        channels = df['channel'].unique()

        plt.figure(figsize=(10,6))
        for index in range(0,len(channels)) :
            channel = index + 1
            color = COLORS[index]
            subset = df[df['channel'] == channel]
            plt.plot(subset['bandwidth(GB/s)'],subset['latency(ns)'],marker='o',linestyle='-',color=color,label=f'{channel}')
        
        plt.xlabel('Bandwidth(GB/s)')
        plt.ylabel('latency(ns)')
        plt.legend()

        plt.xlim(0,70)
        plt.yscale('log', base = 2)
        plt.ylim(64,1024)

        plt.savefig(graph_file)

numa = "remote"
make_csv(numa)
numa = "local"
make_csv(numa)

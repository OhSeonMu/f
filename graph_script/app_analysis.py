import pandas as pd 
import matplotlib.pyplot as plt
from config import *

result_file = result_path + "app_analysis.csv"

def make_analysis_csv(app) : 
    bandwidth_csv = result_path + app + "_bandwidth.csv"
    footprint_csv = output_path + app + "_footprint.csv"
    
    bandwidth = pd.read_csv(bandwidth_csv)
    max_bandwidth = bandwidth["Total, GB/sec:Self"].max()
    footprint = pd.read_csv(footprint_csv)
    max_footprint = footprint['RSS(GB)'].max()
    max_time = len(footprint)

    with open(result_file, 'a') as file:
        file.write(f"{app},{max_footprint},{max_bandwidth},{max_time}\n")

def make_analysis_graph() :
    graph_file = graph_path + "app_analysis.png"
    analysis_csv = result_path + "app_analysis.csv"
    df = pd.read_csv(analysis_csv)

    # all
    # x = df['footprint(GB)']
    # y = df['bandwidth(GB)']
    # plt.figure(figsize=(10, 6))
    # plt.scatter(x, y, color='blue')

    # for i in range(len(analysis)) :
        # plt.text(x[i] + 1, y[i], df['app'][i], fontsize=9, ha='left')

    # plt.xlabel('Memory Footprint(GB)')
    # plt.ylabel('Memory Bandwidth(GB/s)')
    # plt.title('App Analysis')
   
    df['app_type'] = df['app'].str.extract(r'([a-zA-Z]+)')
    
    colors = COLORS
    app_types = df['app_type'].unique()
    color_map = {app_type: colors[i % len(colors)] for i, app_type in enumerate(app_types)}

    plt.figure(figsize=(10, 6))
    for app_type in app_types:
        subset = df[df['app_type'] == app_type]
        plt.scatter(subset['footprint(GB)'], subset['bandwidth(GB)'], color=color_map[app_type], label=app_type)
    
   
    plt.legend(title='App')
    plt.xlabel('Memory Footprint(GB)')
    plt.ylabel('Memory Bandwidth(GB/s)')
    plt.title('App Analysis')

    plt.grid(True)
    plt.savefig(graph_file)
    plt.show()


# with open(result_file, 'w') as file:
#   file.write(f"app,footprint(GB),bandwidth(GB),time(s)\n")

# for app in APPS :
#    print(app)
#    make_analysis_csv(app)

make_analysis_graph()

import pandas as pd 
import matplotlib.pyplot as plt
from config import *

def make_graph(app) : 
    result_file = result_path + app + "_bandwidth.csv"
    graph_file  = graph_path  + app + "_bandwidth.png"
    
    data = pd.read_csv(result_file)

    plt.figure(figsize=(10, 5))
    plt.plot(data['Bin End Time'],data['Total, GB/sec:Self'],marker='o', linestyle='-', color="blue")
    plt.axhline(y=20, color='r', linestyle='--')

    plt.title(app)
    plt.xlabel('Time (s)')
    plt.ylabel('Bandwidth (GB/s)')
    
    plt.ylim(0, 40)
    plt.grid(True)
    
    plt.savefig(graph_file)
    # plt.show()

# make graph
for app in APPS :
    make_graph(app)

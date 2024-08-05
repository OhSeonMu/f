import pandas as pd 
import matplotlib.pyplot as plt

# Directory Info
output_path="../raw_data/"
result_path="../result/"
graph_path="../graph/"

# RW ratio
MODES=[0, 5, 2, 3, 4, 12]
RATIO=["1:0", "1:1", "2:1", "3:1", "3:2", "4:1"]
COLORS=['red', 'orange', 'green', 'blue', 'navy', 'purple']

# Node
NODES=[0,1]

def make_csv(result_file, node, mode) :
    output_file = output_path + "mlc_node" + str(node) + "_mode" + str(mode)
    ratio=RATIO[MODES.index(mode)]
    latency = []
    bandwidth = []
    
    with open(output_file, "r") as file :
        check = 0
        lines = file.readlines()
        for line in lines :
            if "==========================" in line :
                check = 1
                continue

            if check :
                latency.append(line.split()[1])
                bandwidth.append(line.split()[2])
    
    with open(result_file, "a") as file :
        for i in range(0,len(latency)) :
            file.write(f"{ratio},{bandwidth[i]},{latency[i]}\n")

def make_graph(node) : 
    if node :
        result_file = result_path + "mlc_remote.csv"
        graph_file = graph_path + "mlc_remote.png"
    else :
        result_file = result_path + "mlc_local.csv"
        graph_file = graph_path + "mlc_local.png"
    
    data = pd.read_csv(result_file)

    ratios = data['r:w'].unique()

    plt.figure(figsize=(10, 5))
    for index in range(0, len(ratios)) :
        ratio = ratios[index]
        color = COLORS[index]
        subset = data[data['r:w'] == ratio]
        plt.plot(subset['bandwidth(MB/s)'],subset['latency(ns)'],marker='o', linestyle='-', color=color, label=f"{ratio}")

    plt.xlabel('bandwidth (MB/s)')
    plt.ylabel('latency (ns)')
    plt.legend()
    
    #plt.yscale('log', base = 2)
    #plt.ylim(64, 1024)
    plt.ylim(64, 600)
    plt.grid(True)
    
    plt.savefig(graph_file)
    plt.show()

for node in NODES :
    if node :
        result_file = result_path + "mlc_remote.csv"
    else :
        result_file = result_path + "mlc_local.csv"

    with open(result_file, "w") as file :
        file.write("r:w,bandwidth(MB/s),latency(ns)\n")

    # make result 
    for mode in MODES :
        make_csv(result_file, node, mode)
    
    # make graph
    make_graph(node)

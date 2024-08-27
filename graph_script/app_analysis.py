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

    with open(result_file, 'a') as file:
        file.write(f"{app},{max_footprint},{max_bandwidth}\n")

with open(result_file, 'w') as file:
    file.write(f"app,footprint(GB),bandwidth(GB)\n")
for app in APPS :
    make_analysis_csv(app)

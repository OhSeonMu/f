import pandas as pd
import matplotlib.pyplot as plt
from config import *

for MIX in MIXS :
    for LOCAL_RATIO in LOCAL_RATIOS:
        file_path = result_path + str(LOCAL_RATIO) + "_" + MIX + "_total_bandwidth.csv"

        df = pd.read_csv(file_path)

        x = df.index + 1
        # print(df)
        plt.figure(figsize=(12, 6))

        plt.plot(x, (df['Memory (MB/s)']) / 1024, label='Local Bandwidth') # , marker='o')
        plt.plot(x, (df['Memory (MB/s).1']) / 1024, label='Remote Bandwidth') # , marker='o')
        plt.plot(x, (df['Memory (MB/s)'] + df['Memory (MB/s).1']) / 1024, label='Total Bandwidth')

        plt.title(f'{MIX} {LOCAL_RATIOS_MEAN[LOCAL_RATIOS.index(LOCAL_RATIO)]}')
        plt.xlabel('Time (s)')
        plt.ylabel('Bandwidth (GB/s)')
        plt.ylim([0,65])
        plt.legend()
        plt.grid()
        plt.show()

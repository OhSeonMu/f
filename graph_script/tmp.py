import pandas as pd
import matplotlib.pyplot as plt
from config import *

for MIX in MIXS :
    for LOCAL_RATIO in LOCAL_RATIOS:
        file_path = result_path + str(LOCAL_RATIO) + "_" + MIX + "_total_bandwidth.csv"
        df = pd.read_csv(file_path)

        # Local과 Remote Bandwidth를 분리
        local_bandwidth = df[df['event'] == 'local'][['time(s)', 'bandwidth(GB/s)']]
        remote_bandwidth = df[df['event'] == 'remote'][['time(s)', 'bandwidth(GB/s)']]

        # Total Bandwidth 계산
        total_bandwidth = local_bandwidth['bandwidth(GB/s)'].values + remote_bandwidth['bandwidth(GB/s)'].values

        # 그래프 그리기
        plt.figure(figsize=(12, 6))

        plt.plot(local_bandwidth['time(s)'], local_bandwidth['bandwidth(GB/s)'], label='Local Bandwidth') # , marker='o')
        plt.plot(remote_bandwidth['time(s)'], remote_bandwidth['bandwidth(GB/s)'], label='Remote Bandwidth') # , marker='o')
        plt.plot(local_bandwidth['time(s)'], total_bandwidth, label='Total Bandwidth') # , marker='x')

        plt.title(f'{MIX} {LOCAL_RATIOS_MEAN[LOCAL_RATIOS.index(LOCAL_RATIO)]}')
        plt.xlabel('Time (s)')
        plt.ylabel('Bandwidth (GB/s)')
        plt.ylim([0,50])
        plt.legend()
        plt.grid()
        plt.show()


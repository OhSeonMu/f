import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from config import *

TYPE = []
RATIO = []
APP = []
RUNTIME = []

for MIX in MIXS :
    default_run_time_list = []
    for LOCAL_RATIO in LOCAL_RATIOS :
        result_file = result_path + str(LOCAL_RATIO) + "_" + MIX + "_runtime.csv" 
        df = pd.read_csv(result_file)

        if( LOCAL_RATIO == 0 ) :
            default_run_time_list = df['runtime(s)'].tolist()
        
        run_time_list = df['runtime(s)'].tolist()
        run_ratio_list = [a / b for a, b in zip(run_time_list, default_run_time_list)]
        app_name_list = df['app'].tolist()
        type_list = [MIX for a in run_time_list]
        ratio_list = [LOCAL_RATIOS_MEAN[LOCAL_RATIOS.index(LOCAL_RATIO)] for a in run_time_list]

        TYPE.extend(type_list)
        RATIO.extend(ratio_list)
        RUNTIME.extend(run_ratio_list)
        APP.extend(app_name_list)

TMP = [TYPE, RATIO, APP, RUNTIME]
ROWS = zip(TMP[0], TMP[1], TMP[2], TMP[3])
HEADERS = ['mix', 'type', 'app', 'runtime_ratio']

df = pd.DataFrame(data=list(ROWS), columns=HEADERS)

# pd.set_option('display.max_rows', None)  # 모든 행 표시
# pd.set_option('display.max_columns', None)  # 모든 열 표시
# print(df)

# 'mix'와 'type' 별로 groupby하여 'app' 별 runtime_ratio 합산
grouped_data = df.groupby(['mix', 'type', 'app']).sum().reset_index()

# Pivot하여 각 app별로 스택을 위한 데이터 변환
pivot_data = grouped_data.pivot_table(index=['mix', 'type'], columns='app', values='runtime_ratio', fill_value=0)

# 스택된 막대 그래프 그리기
ax = pivot_data.plot(kind='bar', stacked=True, figsize=(10, 6), legend=False)
# ax = pivot_data.plot(kind='bar', stacked=True, figsize=(10, 6), legend=True)

# 그래프에 레이블 추가
plt.xlabel('Mix and Type Combinations')
plt.ylabel('Sum of runtime_ratio')
plt.title('Stacked Bar Chart of runtime_ratio by Mix and Type')

plt.axhline(y=6, color='red', linestyle='--', label='y = 6')

# x축 라벨을 'mix'와 'type' 조합으로 설정
x_labels = [f'{mix}\n{typ}' for mix, typ in pivot_data.index]
plt.xticks(np.arange(len(x_labels)), x_labels, rotation=45, ha='right')

# 스택에 runtime_ratio 값을 추가
for i in range(len(pivot_data)):
        total = 0  # 현재 스택에서의 합계
        for j, col in enumerate(pivot_data.columns):
            value = pivot_data.iloc[i, j]
            if value > 0:  # 값이 있을 때만 표시
                ax.text(i, total + value / 2, f'{value:.2f}', ha='center', va='center', fontsize=9)
            total += value

# 그래프 레이아웃 조정 및 출력
plt.tight_layout()
plt.show()


# Directory Info
output_path="../raw_data/"
result_path="../result/"
graph_path="../graph/"

# For APP/SYSTEM analysis
NODES=[0, 1]
MODES=[0, 5, 2, 3, 4, 12]
RATIO=["1:0", "1:1", "2:1", "3:1", "3:2", "4:1"] 

# App
APPS= [
    # "cdn_high", "cdn_low"
    # "bc_24", "bc_26", "bc_28", 
    # "bfs_24", "bfs_26", "bfs_28",
    # "cc_24", "cc_26", "cc_28",
    # "cc_sv_24", "cc_sv_26", "cc_sv_28",
    # "pr_24", "pr_26", "pr_28",
    # "pr_spmv_24", "pr_spmv_26", "pr_spmv_28", 
    # "sssp_24", "sssp_26", "sssp_28",
    # "tc_24", "tc_26", 
    # "tc_28",
    # "XSBench_large", "XSBench_XL",
    # "XSBench_5", "XSBench_116",
    # "600", "605", "620", "623", "625", "631", "641", "648", "657",
    # "603", "607", "619", "621", "628", "638", "644", "649" 
    # "spec_600", "spec_605", "spec_620", "spec_623", "spec_625", "spec_631", "spec_641", "spec_648", "spec_657",
    # "spec_603", "spec_607", "spec_619", "spec_621", "spec_628", "spec_638", "spec_644", "spec_649" 
]

# Mix 
#LOCAL_RATIOS=[0,1,2,3,5]
# LOCAL_RATIOS_MEAN=["default", "1:1", "2:1", "3:1", "tiering"]
# MIXS=["mix_1", "mix_2", "mix_3", "mix_4"]

LOCAL_RATIOS=[0,1,2,5]
LOCAL_RATIOS_MEAN=["default", "1:1", "2:1", "tiering"]
MIXS=["mix_1","mix_2"]

# COLORS= ['b', 'g', 'r', 'c', 'm', 'y', 'k', 'orange'] 




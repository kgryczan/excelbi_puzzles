import pandas as pd
import numpy as np
from itertools import combinations

path = "1000-1099/1022/1022 Longest Subsequence.xlsx"
input = pd.read_excel(path, usecols="A", nrows = 10)
test = pd.read_excel(path, usecols="B", nrows = 10)

def all_lis(x):
    x = [int(n.strip()) for n in x.split(",")]

    for k in range(len(x), 1, -1):
        result = [
            seq
            for seq in combinations(x, k)
            if all(b > a for a, b in zip(seq, seq[1:]))
        ]
        
        result = list(dict.fromkeys(result))
                
        if result:
            return " | ".join(
                ", ".join(map(str, seq))
                for seq in result
            )
    return np.nan

input['Answer Expected'] = input['Sequence'].apply(all_lis)
# result identical just differently sorted.
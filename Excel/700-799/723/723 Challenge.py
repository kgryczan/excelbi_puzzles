import pandas as pd
import numpy as np

path = "700-799/723/723 Maximum for 3 Consecutive Cells in a Row.xlsx"
input_df = pd.read_excel(path, header=None, skiprows=1, nrows=10, usecols="A:J")
input_matrix = input_df.values
test = pd.read_excel(path, usecols="L", nrows=1).values[0][0]

def max_consecutive_values(input_matrix):
    triplets = []
    for row in input_matrix:
        windows = [row[i:i+3] for i in range(len(row)-2)]
        if not windows:
            continue
        sums = [np.sum(w) for w in windows]
        best_idx = int(np.argmax(sums))
        triplets.append(windows[best_idx])
    if not triplets:
        return ""
    max_triplet_idx = int(np.argmax([np.sum(t) for t in triplets]))
    return ", ".join(str(int(x)) for x in triplets[max_triplet_idx])

result = max_consecutive_values(input_matrix)

print(result == test) #True


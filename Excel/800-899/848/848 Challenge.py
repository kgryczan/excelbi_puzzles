import pandas as pd
import numpy as np

path = "Excel/800-899/848/848 Alignment.xlsx"

input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B:AF", nrows=10)
test = test.fillna("").astype(str).replace(r"\.", "", regex=True)

def align_matrix(words):
    aligned = [list(words[0])]
    for c in map(list, words[1:]):
        a = aligned[-1]
        common = set(c) & set(a)
        if not common:
            aligned.append(c)
            continue
        ch = next(ch for ch in c if ch in a)
        s = a.index(ch) - c.index(ch)
        aligned.append([""] * s + c if s > 0 else c)
    m = max(len(x) for x in aligned)
    return np.array([x + [""] * (m - len(x)) for x in aligned])

aligned_array = align_matrix(input.iloc[:, 0])
aligned_df = pd.DataFrame(aligned_array)
aligned_df.columns = test.columns

print(aligned_df.equals(test)) # True
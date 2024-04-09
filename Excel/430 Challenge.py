import pandas as pd
import numpy as np
import openpyxl

def shift_left(mat, shift_size):
    n_cols = mat.shape[1]
    df = pd.DataFrame(mat)
    shifted_df = df.apply(lambda row: pd.Series(np.roll(row, -shift_size)), axis=1)
    shifted_df = shifted_df.iloc[:, :n_cols]
    return shifted_df.values

# make dict of letters to numbers
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
letter_dict = {}
for i in range(26):
    letter_dict[letters[i]] = i+1

M_final = None

for i in range(26, 0, -1):
    M = np.full((1, 52), np.nan)
    M[0, :i] = np.arange(1, i+1)
    M = np.flip(M, axis=1)
    M = shift_left(M, 53-2*i)

    if i == 26:
        M_final = M
    else:
        M_final = np.vstack((M_final, M))


mf_df = pd.DataFrame(M_final)
mf_df = mf_df.applymap(lambda x: letters[int(x)-1] if not np.isnan(x) else '')

mf_df.to_excel("430 Excel solution PY.xlsx", index=False)
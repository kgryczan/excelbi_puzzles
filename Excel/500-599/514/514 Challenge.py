import pandas as pd
import numpy as np
import itertools

path = "514 Sub Grid Maximum Sum.xlsx"
input = pd.read_excel(path, usecols="B:F", header=None, skiprows=1)
input_mat = input.to_numpy()
test = pd.read_excel(path, usecols="H", nrows = 3)

indices = list(itertools.product(range(input_mat.shape[0] - 1), range(input_mat.shape[1] - 1)))

results = []
for i, j in indices:
    sub_matrix = input_mat[i:i + 2, j:j + 2]
    sub_sum = np.nansum(sub_matrix)
    results.append({'matrix': sub_matrix, 'sum': sub_sum})

max_sum = max(res['sum'] for res in results)
max_subs = [res for res in results if res['sum'] == max_sum]

max_subs_str = [' ; '.join(', '.join(map(str, row)) for row in res['matrix']) for res in max_subs]
max_subs_df = pd.DataFrame({'Answer Expected': max_subs_str})


print(max_subs_df.equals(test)) # True
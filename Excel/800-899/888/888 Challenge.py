import pandas as pd
import numpy as np

path = "Excel/800-899/888/888 Jolly Sequence.xlsx"
input = pd.read_excel(path, usecols="A", nrows=21)
test = pd.read_excel(path, usecols="B", nrows=21)

def jolly_check(a):
    x = np.array(list(map(int, a.split(','))))
    diffs = np.abs(np.diff(x))
    return np.array_equal(np.sort(np.unique(diffs)), np.arange(1, len(x)))

input['Jolly'] = input.iloc[:,0].apply(jolly_check)
input['Answer Expected'] = np.where(input['Jolly'], "Jolly", "Not jolly")

result = input['Answer Expected'].values
expected = test.iloc[:,0].values

print(np.array_equal(result, expected))
# True 
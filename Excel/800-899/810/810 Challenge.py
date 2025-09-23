import pandas as pd
import math
import numpy as np

path = "800-899/810/810 Align Data.xlsx"

input = pd.read_excel(path, usecols="A:F", skiprows=1, nrows=8, header=None).values
test = pd.read_excel(path, usecols="H:I", nrows=9, names=["Left", "Right"])
flat = [x for x in input.flatten() if pd.notna(x)]
zipped = [f"{l}-{n}" for n, l in zip(filter(lambda x: isinstance(x, (int, float)), flat),
                                     filter(lambda x: isinstance(x, str) and x.isalpha(), flat))]
h = (len(zipped) + 1) // 2
result = list(zip(zipped[:h], zipped[::-1][:h-1] + [np.nan]))

df = pd.DataFrame(result, columns=["Left", "Right"])
print(df.equals(test)) # True
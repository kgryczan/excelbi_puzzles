import pandas as pd
import numpy as np

path = "Excel/800-899/849/849 Running Total.xlsx"
input = pd.read_excel(path, usecols="A", nrows=20)
test = pd.read_excel(path, usecols="B", nrows=20)

seq = np.ceil((-1 + np.sqrt(1 + 8 * (np.arange(1, len(input) + 1)))) / 2).astype(int)
df = pd.DataFrame({"Data": input['Data'], "seq": seq})
df["Answer Expected"] = df.groupby("seq")["Data"].cumsum()
df = df.drop(columns=["seq", "Data"])

print(df.equals(test)) # True
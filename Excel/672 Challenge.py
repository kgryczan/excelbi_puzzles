import pandas as pd
import numpy as np

path = "672 Find Level Entries.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=8, names=["Level1", "Level2"])
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=8, names=["Level1", "Level2"])
test['Level2'] = test['Level2'].astype(float)

input['rn'] = range(1, len(input) + 1)
input['Level'] = input['Level1']
input['Level1'] = input['Level1'].ffill()
input = input.sort_values(by=['Level1', 'Level2'])
input = input.apply(pd.to_numeric, errors='coerce')
input["Level2"] = np.where(
    input["Level2"].isna(),
    input["Level1"] - input["Level2"].shift(1),
    input["Level2"]
)
result = input.sort_values(by=['rn'])
result = result[["Level", "Level2"]].rename(columns={"Level": "Level1"})

print(test.equals(result)) # True
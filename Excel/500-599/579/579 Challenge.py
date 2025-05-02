import pandas as pd
import numpy as np

path = "579 Rotated Strings_2.xlsx"

input = pd.read_excel(path, usecols="A:B", nrows = 10)
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=5, header=None, names=["Var1", "Var2"]).sort_values(by="Var1").reset_index(drop=True)

def is_rotated(original, check):
    return check in original + original and original != check and len(original) == len(check)

result = pd.DataFrame(np.array(np.meshgrid(input["String1"], input["String2"])).T.reshape(-1, 2), columns=["Var1", "Var2"])
result["IsRotated"] = result.apply(lambda x: is_rotated(x["Var1"], x["Var2"]), axis=1)
result = result[result["IsRotated"]].sort_values(by="Var1").reset_index(drop=True).drop(columns="IsRotated")

print(result.equals(test))  # True
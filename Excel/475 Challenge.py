import pandas as pd
import re

input = pd.read_excel("475 Split by Positions.xlsx", skiprows=1, usecols="A:B")
test = pd.read_excel("475 Split by Positions.xlsx", skiprows=1, usecols="C:H")

def split_string_by_pos(string, positions_str):
    positions = [int(pos) - 1 for pos in re.split(r"\s*,\s*", positions_str)]
    starts = [0] + positions
    ends = positions + [len(string)]
    return [string[start:end] for start, end in zip(starts, ends)]

result = input.copy()
result["split"] = result.apply(lambda row: split_string_by_pos(row["Names"], row["Position"]), axis=1)
result = result.drop("Position", axis=1).join(result["split"].apply(pd.Series))
result = result.drop(["Names", "split"], axis=1).reset_index(drop=True)
result.columns = test.columns

print(result.equals(test)) # True

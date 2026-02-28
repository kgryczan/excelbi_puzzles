import pandas as pd
import re

path = "Excel/900-999/923/923 Parts and Dimensions.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=19)
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=19).sort_values("Part No.").reset_index(drop=True)

pattern_dims = r"\b\d+(?:\.\d+)?(?:\s*[xX*]\s*\d+(?:\.\d+)?)+\b"
pattern_part = r"P[A-Z0-9]{5}"

def extract_parts(data):
    parts = re.findall(pattern_part, data)
    return ", ".join(parts)
def extract_dims(data):
    dims = re.findall(pattern_dims, data)
    return dims
def sum_dims(dim_list):
    dims = [list(map(float, re.split(r"\s*[xX*]\s*", dim))) for dim in dim_list]
    return [sum(dim) for dim in dims]

input["Part No."] = input["Data"].apply(extract_parts)
input["dimensions"] = input["Data"].apply(extract_dims)
input = input.explode("dimensions")
input["dims"] = input["dimensions"].apply(lambda x: sum(map(float, re.split(r"\s*[xX*]\s*", x))) if pd.notna(x) else 0)

summary = input.groupby("Part No.")["dims"].sum().reset_index(name="dims")
print(summary["dims"].eq(test["Sum of Dimensions"]).all())
# one result is incorrect.
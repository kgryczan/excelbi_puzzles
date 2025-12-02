import pandas as pd
from textwrap import wrap

path = "Excel/800-899/860/860 Splitting Into Lines.xlsx"
input = pd.read_excel(path, sheet_name=0, usecols="A:B", nrows=2)
test = pd.read_excel(path, sheet_name=0, usecols="C:D", skiprows=1, nrows=7, names=["Line", "count"])

wrapped_lines = wrap(input.loc[0, "Text"], width=int(input.loc[0, "Limit Len"]))
output = pd.DataFrame({"Line": wrapped_lines})
output["count"] = output["Line"].str.len().astype(float)

print((output == test).all().all())
# True
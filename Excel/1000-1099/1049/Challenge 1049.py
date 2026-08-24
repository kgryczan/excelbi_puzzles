import numpy as np
import pandas as pd

path = "1000-1099/1049/1049 Zig Zag Allocation.xlsx"
input = pd.read_excel(path, usecols="A", nrows=73, skiprows=1, dtype=str)
test = pd.read_excel(path, usecols="C:E", nrows=44, skiprows=1, dtype=str)

input["t"] = input.Data.str.contains(r"\D")
input["Sequence"] = (input.t & ~input.t.shift(fill_value=False)).cumsum()


def alloc(g):
    x = g.loc[g.t, "Data"].to_numpy()
    i = np.arange(len(x))
    x = x[np.argsort(np.minimum(i, i[::-1]), kind="stable")]
    return pd.DataFrame(
        {"Text": np.resize(x, (~g.t).sum()), "Number": g.loc[~g.t, "Data"].to_numpy()}
    )


result = (
    input.groupby("Sequence")
    .apply(alloc)
    .reset_index(level=0)
    .reset_index(drop=True)
    .astype(str)
)

print(result.equals(test))

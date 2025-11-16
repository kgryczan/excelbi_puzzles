import pandas as pd
import numpy as np
import itertools

path = "Power Query/300-399/340/PQ_Challenge_840.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=16)
test = pd.read_excel(path, usecols="D:G", nrows=5).rename(columns=lambda col: col.replace('.1', ''))

result = input.groupby("Group", as_index=False)["Revenue"].sum()

groups = result["Group"].tolist()
pairs = [(x, y) for x, y in itertools.product(groups, repeat=2) if x != y]
grid = pd.DataFrame(pairs, columns=["x", "y"])

grid = grid.merge(result.rename(columns={"Group": "x", "Revenue": "Revenue_x"}), on="x")
grid = grid.merge(result.rename(columns={"Group": "y", "Revenue": "Revenue_y"}), on="y")

grid["diff"] = (grid["Revenue_x"] - grid["Revenue_y"]).abs()

min_diff = grid.groupby("x")["diff"].min().reset_index().rename(columns={"diff": "min_diff"})
grid = grid.merge(min_diff, on="x")
grid = grid[grid["diff"] == grid["min_diff"]]

out = (
    grid.groupby("x", as_index=False)
    .agg(
        Revenue=("Revenue_x", "first"),
        **{
            "Next Nearest Group": ("y", lambda s: ", ".join(sorted(s))),
            "Next Nearest Group Revenue": ("Revenue_y", "first"),
        }
    )
    .rename(columns={"x": "Group"})
)

print(out.equals(test))
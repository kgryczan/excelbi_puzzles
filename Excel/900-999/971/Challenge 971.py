import pandas as pd
import numpy as np

path = "900-999/971/971 Max of a Contiguous Subarray.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=20, skiprows=1)
test = pd.read_excel(path, usecols="F:G", nrows=4, header=None, skiprows=1, names=["col", "value"])


def max_subarray(nums):
	nums = pd.to_numeric(pd.Series(nums), errors="coerce").dropna().astype(np.int64).to_numpy()
	if len(nums) == 0:
		return np.int64(0)

	best = hi = lo = nums[0]
	for x in nums[1:]:
		vals = (x, hi * x, lo * x)
		hi = max(vals)
		lo = min(vals)
		best = max(best, hi)
	return np.int64(best)


result = pd.DataFrame({"col": input.columns})
result["col"] = "Max_" + result["col"].astype(str)
result["value"] = [max_subarray(input[c]) for c in input.columns]

print(result.equals(test))
# True
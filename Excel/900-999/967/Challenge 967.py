import pandas as pd

path = "900-999/967/967 Sum with Limits.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=21, skiprows=0)
test = pd.read_excel(path, usecols="D", nrows=21, skiprows=0)

def sum_with_limits(sequence, mode, limit):
	nums = [int(x) for x in str(sequence).split(",") if x.strip() != ""]
	if mode == "R":
		nums = list(reversed(nums))
	included = []
	breaks_used = 0
	for num in nums:
		if len(included) == 0 or num > included[-1]:
			included.append(num)
		elif breaks_used < int(limit):
			included.append(num)
			breaks_used += 1
		else:
			break
	return sum(included)
results = input.copy()
results["Answer"] = results.apply(
	lambda row: sum_with_limits(row["Sequence"], row["Mode"], row["Limit"]), axis=1
)
print(results["Answer"].equals(test["Answer Expected"]))\
# True
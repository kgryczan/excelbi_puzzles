import pandas as pd

path = "300-399/320/320 Largest Sum.xlsx"
input_df = pd.read_excel(path, usecols="A", nrows=9)
test     = pd.read_excel(path, usecols="C", nrows=1)

nums = input_df["Numbers"].tolist()
curr = best = nums[0]
for n in nums[1:]:
    curr = max(n, curr + n)
    best = max(best, curr)

result = pd.DataFrame({"Answer Expected": [best]})

print(result.equals(test))
# True

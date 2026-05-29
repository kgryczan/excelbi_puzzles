import pandas as pd

path = "900-999/988/988 Unique Substrings.xlsx"
input = pd.read_excel(path, usecols="A", nrows=19, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=19, skiprows=0)

def find_signatures(string):
	return 0 if len(string) < 3 else len({"".join(sorted(string[i:i + 3])) for i in range(len(string) - 2)})

input["Answer Expected"] = input["Data"].apply(find_signatures)

print(input['Answer Expected'].equals(test['Answer Expected']))
# some expected answers are wrong.
import pandas as pd
import re

path = "900-999/991/991 Opposite Directions Removal.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=21, skiprows=0)
test = pd.read_excel(path, usecols="C:C", nrows=21, skiprows=0).fillna("")


def remove_opposite_directions(directions):
	s = re.sub(r"[, ]", "", directions)
	while True:
		t = re.sub(r"NS|SN|EW|WE", "", s)
		if t == s:
			break
		s = t
	return ",".join(list(s))

input["Output"] = input["Path"].apply(remove_opposite_directions)
print(input['Output'].equals(test['Answer Expected']))
# True
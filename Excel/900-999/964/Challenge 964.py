import pandas as pd

path = "900-999/964/964  Append letters at the end till finish.xlsx"
input = pd.read_excel(path, usecols="A", nrows=7, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=7, skiprows=0)

def decon(string):
	return "".join(string[i:] for i in range(len(string)))
input["Decon"] = [" ".join(decon(word) for word in string.split()) for string in input["Strings"]]

print(input['Decon'].equals(test['Answer Expected']))
# True
from numpy import int64
import pandas as pd

path = "Excel/900-999/908/908 States and Capitals.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=11)

test = pd.read_excel(path, usecols="B:D", skiprows=1, nrows=11)
input["ID"] = input["Data"].str.extract(r"([0-9]{2})").astype(int64)
input["Capital"] = input["Data"].str.extract(r"([A-Z][a-z]+(?:[A-Z][a-z]+)*)")
input["State Code"] = input["Data"].str.extract(r"([A-Z]{2})")

result = input.drop(columns=["Data"])
print(result.equals(test))
# True
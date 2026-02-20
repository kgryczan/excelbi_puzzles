import pandas as pd
import re

path = "Excel/900-999/918/918 Extract Data.xlsx"
input_data = pd.read_excel(path, usecols="B", nrows=1, header=None)
test = pd.read_excel(path, usecols="A:C", skiprows=2, nrows=11)

text = input_data.iloc[0, 0]

def R(pattern):
    return re.findall(pattern, text)

result = pd.DataFrame({
    "Ref Number": R(r"REF-\d{4}"),
    "E Mail ID": R(r"[\w.-]+@[\w.-]+"),
    "Website Address": R(r"(?:www\.|https?://)[\w./-]*[\w/-]")
})

print(test.equals(result))
# Visually i see no difference.

import pandas as pd
import re

input = pd.read_excel("PQ_Challenge_190.xlsx", usecols="A", nrows = 2)
test = pd.read_excel("PQ_Challenge_190.xlsx",  usecols= "A:E", nrows = 2, skiprows=5)

name_pattern = "Name:([\w]+)Org:"
org_pattern = "Org:([\w]+)City:"
city_pattern = "City:([\w]+)FromDate:"
from_date_pattern = "FromDate:([\w]+)ToDate:"
to_date_pattern = "ToDate:([\w]+)"

def extract_and_space(a, pattern):
    return re.sub(r"([A-Z])", r" \1", re.search(pattern, a).group(1)).lstrip()

result = input.copy()
result["Name"] = result["Data"].apply(lambda x: extract_and_space(x, name_pattern))
result["Org"] = result["Data"].apply(lambda x: re.search(org_pattern, x).group(1))
result["City"] = result["Data"].apply(lambda x: extract_and_space(x, city_pattern))
result["From Date"] = result["Data"].apply(lambda x: re.search(from_date_pattern, x).group(1))
result["To Date"] = result["Data"].apply(lambda x: re.search(to_date_pattern, x).group(1))
result["From Date"] = pd.to_datetime(result["From Date"])
result["To Date"] = pd.to_datetime(result["To Date"])
result = result.drop(columns=["Data"])

print(result.equals(test)) # True
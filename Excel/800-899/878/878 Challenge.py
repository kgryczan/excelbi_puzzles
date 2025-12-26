import pandas as pd

path = "Excel/800-899/878/878 Complex Regex Extraction.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=39)
test = pd.read_excel(path, usecols="C:E", skiprows=1, nrows=39)

ref_pattern = r"(?<=REF-)(\d{4})"
email_pattern = r"([A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,})"
web_pattern = r"((?:https?:\/\/|www\.)[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,})"

result = pd.DataFrame()
result['REF'] = input['Log Data'].str.extract(ref_pattern)[0].astype("int64")
result['Mail ID'] = input['Log Data'].str.extract(email_pattern)[0]
result['Web Address'] = input['Log Data'].str.extract(web_pattern)[0]

print(result.equals(test))
# True
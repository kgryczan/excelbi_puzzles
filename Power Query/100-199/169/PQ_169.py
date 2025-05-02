import pandas as pd
import re

input_data = pd.read_excel("PQ_Challenge_169.xlsx", sheet_name="Sheet1", usecols="A")
test_data = pd.read_excel("PQ_Challenge_169.xlsx", sheet_name="Sheet1", usecols="C:D")
test_data["Codes"] = test_data["Codes"].fillna("").astype(str)

pattern = r"\b[A-Z](?=[A-Z0-9]*[0-9])[A-Z0-9]*\b"

result = input_data.copy()
result["Codes"] = result["String"].apply(lambda x: ", ".join(re.findall(pattern, str(x))) if pd.notnull(x) else "")

print(test_data["Codes"].equals(result["Codes"]))   
import re
import pandas as pd

input_data = pd.read_excel("PQ_Challenge_155.xlsx", usecols="A", nrows=10)
test = pd.read_excel("PQ_Challenge_155.xlsx", usecols="D", nrows=10)

def extract_valid_times(text):
    matches = re.findall(r"\d{1,2}:\d{2}", str(text))
    valid = []
    for item in matches:
        hh, mm = item.split(":")
        if int(hh) in range(24) and int(mm) in range(60):
            valid.append(item)
    return ", ".join(valid) if valid else None

result = input_data.assign(extracted=input_data["String"].map(extract_valid_times))
print(result["extracted"].equals(test["Expected Answer"]))

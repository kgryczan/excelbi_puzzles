import re
import pandas as pd

input1 = pd.read_excel("PQ_Challenge_163.xlsx", usecols="A:B", nrows=29)
input2 = pd.read_excel("PQ_Challenge_163.xlsx", usecols="D", nrows=10)
test = pd.read_excel("PQ_Challenge_163.xlsx", usecols="F:G", nrows=10)

pattern = re.compile(r"([A-Z]{2})(\d{2})([A-Z]{2})(\d{4})")
valid_codes = set(input1["Vehicle code"])

rows = []
for idx, raw in enumerate(input2["Data"], start=1):
    text = str(raw).replace(" ", "")
    matches = []
    for m in pattern.finditer(text):
        full = m.group(0)
        p1_valid = m.group(1) in valid_codes
        p2_valid = m.group(3) != "00"
        p4_valid = m.group(4) != "0000"
        if p1_valid and p2_valid and p4_valid:
            matches.append(full)
    rows.append(", ".join(matches) if matches else None)

result = pd.DataFrame({"Vehicle Numbers": rows})
print(result["Vehicle Numbers"].equals(test["Vehicle Numbers"]))

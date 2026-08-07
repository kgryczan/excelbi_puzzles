import csv
import re
from decimal import ROUND_HALF_UP, Decimal

import pandas as pd

path = "1000-1099/1038/1038 Data Extraction.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=20)
test = pd.read_excel(path, usecols="B:C", skiprows=1, nrows=20)


def extract(row):
    fields = next(csv.reader([row]))
    employee, salary = fields[1].strip('"') or pd.NA, fields[-1].strip()
    match = re.fullmatch(r"\+?((?:\d+(?:\.\d+)?|\.\d+))([KMBkmb]?)", salary)
    if not match:
        return employee, pd.NA
    amount = Decimal(match[1]) * {"K": 1_000, "M": 1_000_000, "B": 1_000_000_000}.get(
        match[2].upper(), 1
    )
    return employee, (
        int(amount.quantize(Decimal("1"), rounding=ROUND_HALF_UP))
        if amount > 0
        else pd.NA
    )


result = input.Data.map(extract).apply(pd.Series)
result.columns = test.columns
print(result.convert_dtypes().equals(test.convert_dtypes()))

import pandas as pd
from datetime import datetime

input = pd.read_excel("428 Chinese National ID.xlsx", usecols="A", nrows=10)
test = pd.read_excel("428 Chinese National ID.xlsx", usecols = "B", nrows = 4)

general_pattern = "\\d{6}\\d{8}\\d{3}[0-9X]"

def is_valid_date(ID):
    date_str = ID[6:14]
    try:
        datetime.strptime(date_str, "%Y%m%d")
        return True
    except ValueError:
        return False

def is_ID_valid(ID):
    base = [int(digit) for digit in ID[:17]]
    I = list(range(18, 1, -1))
    WI = [2**(i-1) % 11 for i in I]
    S = sum([digit * weight for digit, weight in zip(base, WI)])
    C = (12 - (S % 11)) % 11
    C = 'X' if C == 10 else str(C)

    whole_id = ''.join(map(str, base)) + C
    return whole_id == ID

r1 = input.copy()
r1 = input[input['National ID'].str.match(general_pattern).fillna(False)]
r1 = r1[r1['National ID'].apply(is_valid_date)]
r1 = r1[r1['National ID'].apply(is_ID_valid)].reset_index(drop=True)
r1.rename(columns={"National ID": "Answer Expected"}, inplace=True)

print(r1.equals(test)) # True
import pandas as pd
import numpy as np
import re

path = "900-999/986/986 Fill the Diagonals of Squares.xlsx"
input1 = pd.read_excel(path, usecols="B:F", nrows = 5, skiprows = 1, header=None, dtype=str).map(lambda x: x.strip() if isinstance(x, str) else x).to_numpy()
input2 = pd.read_excel(path, usecols="B:D", nrows = 3, skiprows = 9, header=None, dtype=str).map(lambda x: x.strip() if isinstance(x, str) else x).to_numpy()
input3 = pd.read_excel(path, usecols="B:H", nrows = 7, skiprows = 14, header=None, dtype=str).map(lambda x: x.strip() if isinstance(x, str) else x).to_numpy()

test1 = pd.read_excel(path, usecols="L:P", nrows = 5, skiprows = 1, header=None, dtype=str).map(lambda x: re.sub(r"\s+", "", x) if isinstance(x, str) else x).fillna("").to_numpy()
test2 = pd.read_excel(path, usecols="L:N", nrows = 3, skiprows = 9, header=None, dtype=str).map(lambda x: re.sub(r"\s+", "", x) if isinstance(x, str) else x).fillna("").to_numpy()
test3 = pd.read_excel(path, usecols="L:R", nrows = 7, skiprows = 14, header=None, dtype=str).map(lambda x: re.sub(r"\s+", "", x) if isinstance(x, str) else x).fillna("").to_numpy()

def fill_diagonal(arr):
    d, n, c = pd.DataFrame(arr), len(arr), len(arr) // 2

    def clean_value(x):
        s = str(x).strip()
        if s == "" or s.upper() == "X" or s.lower() == "nan": return None
        if re.fullmatch(r"-?\d+(?:\.\d+)?", s):
            v = float(s)
            return str(int(v)) if v.is_integer() else str(v)
        return s

    diag1_vals, diag2_vals, all_diag_vals = [], [], []
    for i in range(n):
        v1, v2 = clean_value(d.iat[i, i]), clean_value(d.iat[i, n - 1 - i])
        if v1 is not None:
            all_diag_vals.append(v1)
            if i != c: diag1_vals.append(v1)
        if v2 is not None:
            all_diag_vals.append(v2)
            if i != c: diag2_vals.append(v2)

    center = clean_value(d.iat[c, c]) or ""
    result = np.full((n, n), "", dtype=object)
    d1, d2 = (diag1_vals[0] if diag1_vals else center), (diag2_vals[0] if diag2_vals else center)
    for i in range(n):
        result[i, i], result[i, n - 1 - i] = d1, d2

    def sort_key(x):
        try: return (0, float(x))
        except ValueError: return (1, x)

    result[c, c] = ",".join(sorted(set(all_diag_vals), key=sort_key))
    return result

r1 = fill_diagonal(input1)
r2 = fill_diagonal(input2)
r3 = fill_diagonal(input3)

print(np.array_equal(r1, test1))
print(np.array_equal(r2, test2))
print(np.array_equal(r3, test3))

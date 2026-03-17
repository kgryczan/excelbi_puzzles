import pandas as pd

path = "900-999/935/935 Prefixes.xlsx"
input_df = pd.read_excel(path, usecols="A", skiprows=1, nrows=24)
test = pd.read_excel(path, usecols="B", skiprows=1, nrows=24)

codes = input_df["Code"].tolist()


def shortest_unique_prefix(code, all_codes):
    for length in range(1, len(code) + 1):
        prefix = code[:length]
        if sum(1 for c in all_codes if c.startswith(prefix)) == 1:
            return prefix
    return code


result = pd.DataFrame({"SUP": [shortest_unique_prefix(c, codes) for c in codes]})

print(result.equals(test))

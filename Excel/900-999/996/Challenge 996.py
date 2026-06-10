import pandas as pd

path = "900-999/996/996 Abbreviation for List of Elements.xlsx"
input = pd.read_excel(path, usecols="A", nrows=118, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=118, skiprows=0)


def shortest_unique_prefixes(words: list[str]) -> list[str]:
    used: list[str] = []
    out: list[str] = []
    for word in words:
        x = str(word).strip()
        prefixes = [x[:i] for i in range(1, len(x) + 1)]
        abbr = next((p for p in prefixes if p not in used), x)
        used.append(abbr)
        out.append(abbr)
    return out


result = input.assign(Answer=shortest_unique_prefixes(input["Elements"].tolist()))
print(result["Answer"].equals(test["Answer Expected"]))
# True

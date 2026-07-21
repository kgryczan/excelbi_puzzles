import pandas as pd
from collections import Counter

path = "1000-1099/1025/1025 Grouping.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=20)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=7, dtype=str)

codes = input["Code"].map(Counter).tolist()


def distance(a, b):
    return sum((a - b).values()) + sum((b - a).values())


components, unseen = [], set(range(len(codes)))
while unseen:
    component = {unseen.pop()}
    while additions := {
        j for j in unseen if any(distance(codes[j], codes[i]) <= 1 for i in component)
    }:
        component |= additions
        unseen -= additions
    components.append(sorted(component))

result = pd.DataFrame(
    {
        "Group": [f"G{number}" for number in range(1, len(components) + 1)],
        "IDs": [
            input.loc[component, "ID"].astype(int).astype(str).str.cat(sep=",")
            for component in components
        ],
    }
)

print(result.equals(test))
# True

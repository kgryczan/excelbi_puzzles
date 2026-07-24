import pandas as pd

path = "1000-1099/1028/1028 Extract Name and Score.xlsx"
input = pd.read_excel(path, usecols="A", nrows=20, skiprows=1)
test = pd.read_excel(path, usecols="B:C", nrows=20, skiprows=1)

pattern = r'^\d+,("[^"]*"|\'[^\']*\'|[^,]*),(?:"[^"]*"|\'[^\']*\'|[^,]*),(?:"[^"]*"|\'[^\']*\'|[^,]*),("[0-9]+"|\'[0-9]+\'|[0-9]+)$'

result = (
    input["CSV Data"]
    .str.extract(pattern)
    .set_axis(["Name", "Score"], axis=1)
    .assign(
        Name=lambda x: x["Name"]
        .str.strip("'\"")
        .apply(lambda s: " ".join(reversed(s.split(", "))) if "," in s else s),
        Score=lambda x: x["Score"].str.strip("'\"").astype(int),
    )
)

print(result.equals(test))
# True

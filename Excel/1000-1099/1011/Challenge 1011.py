import pandas as pd

path = "1000-1099/1011/1011 Visiting Countries.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=21, skiprows=0)
test = pd.read_excel(path, usecols="D", nrows=21, skiprows=0)

remaining = (
    input.dropna(subset=["Country", "Latitude"])
    .assign(Latitude=lambda d: pd.to_numeric(d["Latitude"], errors="coerce"))
    .dropna(subset=["Latitude"])
    .reset_index(drop=True)
)

route = []
if not remaining.empty:
    i = remaining["Latitude"].idxmax()
    while True:
        current = remaining.loc[i]
        route.append(current["Country"])
        remaining = remaining.drop(index=i)
        if remaining.empty:
            break
        i = (remaining["Latitude"] - current["Latitude"]).abs().idxmin()

route_df = pd.DataFrame({"Visit Order": range(1, len(route) + 1), "Country": route})
print(route_df["Country"].equals(test["Answer Expected"]))
# True

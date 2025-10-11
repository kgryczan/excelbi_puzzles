import pandas as pd

path = "300-399/329/PQ_Challenge_329.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=12).ffill()
test = pd.read_excel(path, usecols="E:F", nrows=18).fillna("None")

input["cap"] = input["Cities"].str.contains(r"\(C\)")
input["city"] = input["Cities"].str.replace(r" \(C\)", "", regex=True)

agg = (input.groupby(["Country", "State"], sort=False)
    .apply(lambda g: pd.Series({
        "Capital": g.loc[g.cap, "city"].drop_duplicates().iloc[0] if g.cap.any() else "None",
        "Other Cities": ", ".join(g.loc[~g.cap, "city"].drop_duplicates()) or "None"
    })).reset_index())

rows = []
for c in input["Country"].drop_duplicates():
    rows.append(pd.DataFrame({"Type": ["Country"], "City": [c]}))
    for s in input.loc[input["Country"].eq(c), "State"].drop_duplicates():
     r = agg.query("Country == @c and State == @s").iloc[0]
     rows.append(pd.DataFrame({
         "Type": ["State", "Capital", "Other Cities"],
         "City": [s, r["Capital"], r["Other Cities"]]
     }))

result = pd.concat(rows, ignore_index=True)
result.columns = test.columns
print(result.equals(test))

import pandas as pd

input_data = pd.read_excel("PQ_Challenge_152.xlsx", usecols="A:D", nrows=17)
input_data.columns = [c.strip().lower().replace(" ", "_") for c in input_data.columns]
test = pd.read_excel("PQ_Challenge_152.xlsx", usecols="F:I", nrows=5)
test.columns = [c.strip().lower() for c in test.columns]

result = input_data.copy()
result["seq"] = result.apply(lambda r: pd.date_range(r["from_date"], r["to_date"], freq="D"), axis=1)
result = result.explode("seq").drop(columns=["from_date", "to_date"])
result["value"] = 1
wide = result.pivot_table(index=["name", "seq"], columns="type_of_leave", values="value", fill_value=0, aggfunc="sum").reset_index()
wide = wide[["name", "seq", "ML", "PL", "CL"]]
wide["sum"] = wide["ML"] + wide["PL"] + wide["CL"]
wide["concat"] = (wide["ML"].astype(str) + wide["PL"].astype(str) + wide["CL"].astype(str)).astype(int)
wide["main_leave"] = wide.apply(
    lambda r: "ML" if (r["sum"] == 1 and r["ML"] == 1) or (r["sum"] == 2 and r["concat"] >= 100) or (r["sum"] == 3)
    else ("PL" if (r["sum"] == 1 and r["PL"] == 1) or (r["sum"] == 2 and r["concat"] < 100)
    else ("CL" if r["sum"] == 1 and r["CL"] == 1 else "NA")),
    axis=1,
)
wide["wday"] = pd.to_datetime(wide["seq"]).dt.weekday + 1
wide = wide[~wide["wday"].isin([6, 7])]
result2 = (
    wide.assign(main_leave=wide["main_leave"].str.lower())
    .groupby(["name", "main_leave"], as_index=False)
    .size()
    .rename(columns={"size": "days"})
    .pivot(index="name", columns="main_leave", values="days")
    .fillna(0)
    .reset_index()
)
result2.columns.name = None
for col in ["ml", "pl", "cl"]:
    if col not in result2.columns:
        result2[col] = 0
result2 = result2[["name", "ml", "pl", "cl"]]

print(result2.equals(test))

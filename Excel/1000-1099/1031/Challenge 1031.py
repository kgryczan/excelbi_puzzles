import pandas as pd

p = "1000-1099/1031/1031 Room Tariff.xlsx"
rooms = pd.read_excel(p, usecols="A:D", skiprows=1, nrows=20)
expected = pd.read_excel(p, usecols="F:G", skiprows=1, nrows=4)
expected.columns = ["Room_Type", "Dec_Revenue"]

dec_start, dec_end = pd.Timestamp("2026-12-01"), pd.Timestamp("2027-01-01")
peak_start = pd.Timestamp("2026-12-26")

rooms["out"] = rooms["Check_Out"].fillna(dec_end)
rooms["from"] = rooms["Check_In"].clip(lower=dec_start)
rooms["to"] = rooms["out"].clip(upper=dec_end)
rooms["nights"] = (rooms["to"] - rooms["from"]).dt.days.clip(lower=0)
rooms["full_december"] = (rooms["Check_In"] <= dec_start) & (
    rooms["Check_Out"].isna() | (rooms["Check_Out"] >= dec_end)
)
rooms["surcharge_nights"] = (
    rooms["to"].clip(lower=peak_start) - rooms["from"].clip(lower=peak_start)
).dt.days.clip(lower=0)
rooms.loc[rooms["full_december"], "surcharge_nights"] = 0
rooms["revenue"] = rooms["nights"] * rooms["Base_Rate"] + rooms["surcharge_nights"] * 50

result = (
    rooms.groupby("Room_Type", as_index=False)["revenue"]
    .sum()
    .rename(columns={"revenue": "Dec_Revenue"})
    .sort_values("Room_Type")
    .reset_index(drop=True)
)

print(result)
print("Matches expected:", result.equals(expected))

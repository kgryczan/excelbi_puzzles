import pandas as pd

path = "PQ_Challenge_210.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=0, nrows=17)
test = pd.read_excel(path, usecols="E:H", skiprows=0, nrows=9)
test.columns = test.columns.str.replace(".1", "")

r1 = input[["Name", "Date"]].copy()
r1["Date"] = pd.to_datetime(r1["Date"])
r1 = r1.set_index("Date").resample("D").ffill().reset_index()

r2 = r1.merge(input, on = ["Name", "Date"], how = "left")
r2["Weekday_num"] = r2["Date"].dt.weekday
r2["Type"] = r2["Type"].where(r2["Weekday_num"] != 5, r2["Type"].shift(1))
r2["Type"] = r2["Type"].where(r2["Weekday_num"] != 6, r2["Type"].shift(2))

r2["Group"] = r2["Type"].ne(r2["Type"].shift()).cumsum()
r2 = r2.dropna(subset = ["Type"])
r2 = r2[~r2["Weekday_num"].isin([5, 6])]
r2 = r2.groupby(["Name", "Type", "Group"]).agg({"Date": ["min", "max"]}).reset_index()
r2.columns = r2.columns.droplevel()
r2.columns = ["Name", "Type", "Group", "From Date", "To Date"]
r2 = r2.sort_values(["Name", "To Date"], ascending = [False, True]).reset_index(drop = True)
r2 = r2[["Name", "From Date", "To Date", "Type"]]

print(r2.equals(test)) # True

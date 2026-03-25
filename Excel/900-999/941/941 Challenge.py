import pandas as pd

path = "900-999/941/941 Prorate Amount.xlsx"
input = pd.read_excel(path, usecols="A:D", skiprows=1, nrows=21)
test = pd.read_excel(path, usecols="F:L", skiprows=1, nrows=4).rename(columns=lambda c: c.rstrip(".1"))

input["Start_Date"] = pd.to_datetime(input["Start_Date"]).dt.date
input["End_Date"] = pd.to_datetime(input["End_Date"]).dt.date
input["days"] = (pd.to_datetime(input["End_Date"]) - pd.to_datetime(input["Start_Date"]) ).dt.days + 1
input["daily"] = input["Amount"] / input["days"]
input = input.assign(date=input.apply(lambda r: pd.date_range(r.Start_Date, r.End_Date), axis=1)).explode("date")
input["month"] = input["date"].dt.month
res = (
    input[input["month"].between(1, 6)]
    .groupby(["Org", "month"])['daily']
    .sum()
    .unstack(fill_value=0)
)
res = res.rename(columns={1: 'Jan', 2: 'Feb', 3: 'Mar', 4: 'Apr', 5: 'May', 6: 'Jun'}).reset_index()
for m in ['Jan','Feb','Mar','Apr','May','Jun']:
    if m not in res.columns:
        res[m] = 0.0
res = res[['Org','Jan','Feb','Mar','Apr','May','Jun']]
res = res.fillna(0)
res[['Jan','Feb','Mar','Apr','May','Jun']] = res[['Jan','Feb','Mar','Apr','May','Jun']].round().astype('int64')

print(res.equals(test))
# True

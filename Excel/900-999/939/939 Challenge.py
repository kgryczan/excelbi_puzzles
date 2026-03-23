import pandas as pd

path = "900-999/939/939 Location Update.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=20)
test = pd.read_excel(path, usecols="E:G", skiprows=1, nrows=20)
test.columns = input.columns

latest_loc = (
    input.loc[input.groupby("Name")["Date"].idxmax(), ["Name", "Location"]]
    .set_index("Name")["Location"]
)
result = input.copy()
result["Location"] = result["Name"].map(latest_loc)

print(result.equals(test))
# True

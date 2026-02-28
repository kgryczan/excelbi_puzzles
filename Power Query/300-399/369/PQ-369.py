import pandas as pd

path = "Power Query/300-399/369/PQ_Challenge_369.xlsx"

input = pd.read_excel(path, usecols="A", nrows=21, header=None)
test = pd.read_excel(path, usecols="C:E", nrows=3)

input = input[0].str.split(",", expand=True)
input.columns = input.iloc[0]
input = input[1:]

input["CreatedDate"] = pd.to_datetime(input["CreatedDate"], errors='coerce')
input["Status"] = input["NewValue"].combine_first(input["OldValue"])
input = input.sort_values(by=["ParentId", "CreatedDate"])

result = input.groupby("ParentId").agg(
    Status_Path=("Status", lambda x: " > ".join(x.dropna())),
    Lifecycle_Days=("CreatedDate", lambda x: (x.max() - x.min()).days)
).reset_index().rename(columns={"Status_Path": "Status Path", "Lifecycle_Days": "Lifecycle Days"})
print(result.equals(test))
# > True
from numpy import int64
import pandas as pd

path = "300-399/388/PQ_Challenge_388.xlsx"

input1 = pd.read_excel(path, usecols="A", nrows=6, header=None)
input2 = pd.read_excel(path, usecols="A", nrows=21, skiprows=8, header=None)
test = pd.read_excel(path, usecols="D:G", nrows=20, skiprows=0)

i1 = input1.iloc[:, 0].str.split(",", expand=True)
i1.columns = i1.iloc[0]
i1 = i1.iloc[1:].reset_index(drop=True)
for col in ["ShiftStart", "ShiftEnd"]:
    if col in i1.columns:
        i1[col] = pd.to_datetime(i1[col], errors="coerce")
i2 = input2.iloc[:, 0].str.split(",", expand=True)
i2.columns = i2.iloc[0]
i2 = i2.iloc[1:].reset_index(drop=True)
if "ActionTime" in i2.columns:
    i2["ActionTime"] = pd.to_datetime(i2["ActionTime"], errors="coerce")
i2['LogID'] = i2['LogID'].astype(int64)
result = (
    i2.merge(i1, on="EmpID", how="left")
    .assign(
        ShiftName=lambda df: df["ShiftName"].where(
            df["ActionTime"].between(df["ShiftStart"], df["ShiftEnd"], inclusive="both"),
            pd.NA,
        )
    )
    .groupby(["LogID", "EmpID", "ActionTime"], as_index=False)
    .agg(
        ShiftName=(
            "ShiftName",
            lambda s: s.dropna().iloc[0] if not s.dropna().empty else pd.NA,
        )
    )
)
print(result.equals(test))
# correct. NAs are incomparable.

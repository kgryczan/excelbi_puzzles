import pandas as pd

input_data = pd.read_excel("PQ_Challenge_149.xlsx", usecols="A:D", nrows=6)
input_data.columns = [c.strip().lower() for c in input_data.columns]
test = pd.read_excel("PQ_Challenge_149.xlsx", usecols="F:I", nrows=12)
test.columns = [c.strip().lower() for c in test.columns]
test = test.sort_values(["employee", "start_date"]).reset_index(drop=True)

result = input_data.copy()
result["days"] = result.apply(lambda r: pd.date_range(r["start_date"], r["end_date"], freq="D"), axis=1)
result = result.explode("days")
result["month"] = result["days"].values.astype("datetime64[M]")
result = (
    result.groupby(["employee", "per_diem", "month"], as_index=False)
    .agg(n_days=("days", "size"), start_date=("days", "min"), end_date=("days", "max"))
)
result["per_diem"] = result["n_days"] * result["per_diem"]
result = result[["employee", "start_date", "end_date", "per_diem"]].sort_values(["employee", "start_date"]).reset_index(drop=True)

print(result.equals(test))

import pandas as pd

path = "300-399/371/PQ_Challenge_371.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=21)
test = pd.read_excel(path, usecols="E:I", nrows=6)

result = (
    input
    .assign(
        Status_Occurrence=(input["Event Type"] == "Status").cumsum(),
        Status=input["Value"].where(input["Event Type"] == "Status")
    )
    .assign(Status=lambda df: df["Status"].ffill())
    .loc[lambda df: df["Event Type"] != "Status"]
    .groupby(["Status_Occurrence", "Status"], sort=False)
    .agg(
        **{
            "Average Reading": ("Value", lambda x: pd.to_numeric(x).mean()),
            "Max Reading":     ("Value", lambda x: pd.to_numeric(x).max()),
            "Min Reading":     ("Value", lambda x: pd.to_numeric(x).min()),
        }
    )
    .reset_index()
    .rename(columns={"Status_Occurrence": "Status Occurrence"})
)

result.equals(test)
# True
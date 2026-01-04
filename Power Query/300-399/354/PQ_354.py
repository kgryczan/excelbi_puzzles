import pandas as pd

path = "Power Query/300-399/354/PQ_Challenge_354.xlsx"
input_data = pd.read_excel(path, usecols="A:C", nrows=51)
test = pd.read_excel(path, usecols="E:J", nrows=51).rename(columns=lambda col: col.replace(".1", ""))

result = (
    input_data
    .assign(Date=lambda x: pd.to_datetime(x["Date"], dayfirst=True))
    .assign(
        **{
            "Sum Trade": lambda x:
                x.groupby(["Date", "Profession", "Type"])["Date"]
                 .transform("count")
        }
    )
    .assign(
        **{
            "Total Trade": lambda x:
                x.groupby("Date")["Sum Trade"]
                 .transform("sum")
        }
    )
    .sort_values(["Total Trade", "Date"], ascending=[False, False])
    .assign(
        Rank=lambda x:
            x.groupby(["Total Trade", "Date"], sort=False)
             .ngroup()
             .add(1)
    )
    .reset_index(drop=True)
    [["Date", "Profession", "Type", "Sum Trade", "Total Trade", "Rank"]]
)

print(result.equals(test))  # True

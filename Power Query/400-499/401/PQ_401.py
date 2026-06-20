import pandas as pd

path = "400-499/401/PQ_Challenge_401.xlsx"
sheet = "Sheet1 (2)"


def read_and_trim(path, sheet, usecols, nrows):
    df = pd.read_excel(path, sheet_name=sheet, usecols=usecols, nrows=nrows)
    df.columns = df.columns.str.strip()
    return df.map(lambda x: x.strip() if isinstance(x, str) else x)


input_df = read_and_trim(path, sheet, "A:D", 30)
test = read_and_trim(path, sheet, "F:J", 16)

df = input_df.assign(
    start_date=pd.to_datetime(input_df["StartDate"]),
    end_date=pd.to_datetime(input_df["EndDate"]),
)

df_long = (
    df.assign(
        Date=[pd.bdate_range(s, e) for s, e in zip(df["start_date"], df["end_date"])]
    )
    .explode("Date")
    .dropna(subset=["Date"])
    .sort_values(["AccountID", "Date"])
)

df_long["diff_d"] = df_long.groupby(["AccountID", "OwnerID"])["Date"].diff().dt.days
df_long["consecutive_id"] = (
    (df_long["diff_d"].isna() | ~df_long["diff_d"].isin([0, 1, 3]))
    .groupby([df_long["AccountID"], df_long["OwnerID"]])
    .cumsum()
)

result = (
    df_long.assign(
        cons_won=df_long["OwnerID"] + "_" + df_long["consecutive_id"].astype(str)
    )
    .groupby(["AccountID", "OwnerID", "cons_won"], as_index=False, sort=False)
    .agg(EpisodeStart=("Date", "min"), EpisodeEnd=("Date", "max"))
    .assign(
        EpisodeStart=lambda x: x["EpisodeStart"].dt.strftime("%Y-%m-%d"),
        EpisodeEnd=lambda x: x["EpisodeEnd"].dt.strftime("%Y-%m-%d"),
        EpisodeNo=lambda x: x.groupby("AccountID").cumcount().add(1).astype(str),
    )[["AccountID", "EpisodeNo", "EpisodeStart", "EpisodeEnd", "OwnerID"]]
)
test.columns = result.columns

print(result.equals(test))
# True

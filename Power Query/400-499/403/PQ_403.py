import pandas as pd
import numpy as np

path = "400-499/403/PQ_Challenge_403.xlsx"
input_df = pd.read_excel(path, usecols="A:D", nrows=12, skiprows=0)
test_df = pd.read_excel(path, usecols="G:K", nrows=36, skiprows=0)


def round_half_away_from_zero(x):
    x = np.asarray(x, dtype=float)
    return np.trunc(x + np.copysign(0.5, x)).astype(int)


def last_friday(y, m):
    last_day = pd.Timestamp(year=int(y), month=int(m), day=1) + pd.offsets.MonthEnd(0)
    return last_day - pd.Timedelta(days=(last_day.dayofweek - 4) % 7)


parts = (
    input_df["FiscalQuarter"]
    .astype(str)
    .str.extract(r"FY(\d{4})-Q(\d)")
    .astype("int64")
)
input_df = input_df.assign(year=parts[0], q=parts[1])

result = (
    input_df.assign(
        fiscal_month=lambda d: d["q"].apply(
            lambda q: [(q - 1) * 3 + 2, (q - 1) * 3 + 3, (q - 1) * 3 + 4]
        ),
        weights=lambda d: d["SplitPattern"]
        .astype("int64")
        .astype(str)
        .str.zfill(3)
        .apply(lambda s: [int(ch) for ch in s]),
    )
    .explode(["fiscal_month", "weights"], ignore_index=True)
    .assign(
        cal_year=lambda d: d["year"] + (d["fiscal_month"] > 12).astype("int64"),
        month_no=lambda d: ((d["fiscal_month"] - 1) % 12) + 1,
        Month=lambda d: pd.to_datetime(
            d["cal_year"].astype(str)
            + "-"
            + d["month_no"].astype(str).str.zfill(2)
            + "-01"
        ),
        MonthlyAmount=lambda d: round_half_away_from_zero(
            d["Amounts"] * d["weights"] / 13
        ),
        PostingDate=lambda d: d.apply(
            lambda r: last_friday(r["cal_year"], r["month_no"]), axis=1
        ),
    )
)
base_amount = result.groupby(["Division", "FiscalQuarter"])["Amounts"].transform(
    "first"
)
sum_monthly = result.groupby(["Division", "FiscalQuarter"])["MonthlyAmount"].transform(
    "sum"
)
result["MonthlyAmount"] = result["MonthlyAmount"] + (
    (result["weights"] == 5) * (base_amount - sum_monthly)
).astype("int64")

result = result[
    ["Division", "FiscalQuarter", "Month", "PostingDate", "MonthlyAmount"]
].reset_index(drop=True)
expected = (
    test_df.rename(
        columns={"Division.1": "Division", "FiscalQuarter.1": "FiscalQuarter"}
    )
    .assign(
        Month=lambda d: pd.to_datetime(d["Month"]),
        PostingDate=lambda d: pd.to_datetime(d["PostingDate"]),
    )[["Division", "FiscalQuarter", "Month", "PostingDate", "MonthlyAmount"]]
    .reset_index(drop=True)
)

result.equals(expected)

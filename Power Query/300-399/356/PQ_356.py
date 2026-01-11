import pandas as pd
import numpy as np

path = "Power Query/300-399/356/PQ_Challenge_356.xlsx"
input = pd.read_excel(path, usecols="A:F", nrows=50)
test = pd.read_excel(path, usecols="I:L", nrows=50)

df = input.copy()
df["peer_avg"] = (
    df.groupby(["Region", "Type", "Beds"])["Price"]
      .expanding()
      .mean()
      .reset_index(level=[0,1,2], drop=True)
)
df["reg_avg"] = (
    df.groupby("Region")["Price"]
      .expanding()
      .mean()
      .reset_index(level=0, drop=True)
)
df["reg_hist_avg"] = (
    df.groupby("Region")["reg_avg"].shift().fillna(0)
)
df["prem_disc"] = np.where(
    df["reg_hist_avg"] == 0,
    0,
    ((df["Price"] - df["reg_hist_avg"]) * 100 / df["reg_hist_avg"]).round(2)
)
def expanding_q(s, q):
    return pd.Series(
        [np.nan if i == 0 else s.iloc[:i].quantile(q)
         for i in range(len(s))],
        index=s.index
    )
df["q25"] = (
    df.groupby("Type")["Price"]
      .apply(lambda s: expanding_q(s, .25))
      .reset_index(level=0, drop=True)
)
df["q75"] = (
    df.groupby("Type")["Price"]
      .apply(lambda s: expanding_q(s, .75))
      .reset_index(level=0, drop=True)
)
df["Tier"] = np.select(
    [df["Price"] < df["q25"], df["Price"] > df["q75"]],
    ["Entry", "Luxury"],
    default="Mid-Market"
)
result = df[["ID", "peer_avg", "prem_disc", "Tier"]].rename(columns={
    "peer_avg": "Specific Peer Avg",
    "prem_disc": "Premium / Discount %",
    "Tier": "Tier Status"
})

# Not all cases correct.
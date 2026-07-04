import pandas as pd

path = "400-499/405/PQ_Challenge_405.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=25, skiprows=0)
test = pd.read_excel(path, usecols="F:O", nrows=6, skiprows=0)

m = (
    input.loc[input.index.repeat(2), ["MatchID"]]
    .reset_index(drop=True)
    .assign(
        Team=input[["HomeTeam", "AwayTeam"]].stack().to_numpy(),
        GF=input["Score"].str.split("-").explode().astype(int).to_numpy(),
    )
)
m["GA"] = m.groupby("MatchID")["GF"].transform("sum") - m["GF"]
result = (
    m.assign(W=m.GF.gt(m.GA), D=m.GF.eq(m.GA), L=m.GF.lt(m.GA))
    .groupby("Team", as_index=False)
    .agg(
        Played=("GF", "size"),
        Wins=("W", "sum"),
        Draws=("D", "sum"),
        Losses=("L", "sum"),
        GF=("GF", "sum"),
        GA=("GA", "sum"),
    )
    .assign(GD=lambda d: d.GF - d.GA, Points=lambda d: d.Wins * 3 + d.Draws)
    .sort_values(
        ["Points", "GD", "GF", "Team"],
        ascending=[False] * 3 + [True],
        ignore_index=True,
    )
)
result.insert(0, "Rank", result.index + 1)

print(result.equals(test))
# True

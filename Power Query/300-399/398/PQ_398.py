import pandas as pd

path = "300-399/398/PQ_Challenge_398.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=27, skiprows=0)
test = pd.read_excel(path, usecols="F:K", nrows=6, skiprows=0).rename(columns=lambda c: c.rstrip(".1") if c.endswith(".1") else c)


def compute_group(g):
    p = g.Cleared.mean()
    cur = "Not Started" if p == 0 else g.loc[g.Cleared, "StageName"].iat[-1]
    nxt = "Completed" if p == 1 else g.loc[~g.Cleared, "StageName"].iat[0] if p == 0 else g.iloc[g.index.get_loc(g.index[g.StageName.eq(cur)][0]) + 1]["StageName"]
    status = "Completed" if p == 1 else "Not Started" if p == 0 else "In Progress"
    n = None if cur == "Not Started" else g.loc[g.StageName.eq(cur), "StageNo"].iat[0]
    issue = "No" if n is None else "Yes" if ((g.StageNo < n) & ~g.Cleared).any() else "No"
    return pd.Series({"CurrentStage": cur, "NextStage": nxt, "Status": status, "ProcessIssue": issue, "ProgressPct": p})


result = input.groupby("CaseID", sort=False).apply(compute_group).reset_index()

print(result.equals(test))
# True

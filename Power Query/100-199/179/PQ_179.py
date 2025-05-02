import pandas as pd

input = pd.read_excel("PQ_Challenge_179.xlsx",  usecols="A:C", nrows=10)
test = pd.read_excel("PQ_Challenge_179.xlsx",  usecols="E:K", nrows=3)
test = test.rename(columns={"Team.1": "Team"}).sort_values("Team").reset_index(drop=True)

r1 = input.copy()
r1 = r1[["Team", "Player"]]
r1["row"] = r1.groupby("Team").cumcount()+1
r1 = r1.pivot(index="Team", columns="row", values="Player").add_prefix("Player").reset_index()

r2 = input.copy()
r2["Max"] = r2.groupby("Team")["Runs Scored"].transform("max")
r2 = r2[r2["Runs Scored"] == r2["Max"]]
r2 = r2.groupby("Team").agg({"Player": lambda x: ", ".join(x), "Max": "first"}).reset_index()

result = r1.merge(r2, on="Team", how="left")
result.columns = test.columns

print(result.equals(test)) # True
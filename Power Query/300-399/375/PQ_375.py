import pandas as pd
from collections import defaultdict

path = "300-399/375/PQ_Challenge_375.xlsx"
input_df = pd.read_excel(path, usecols="A:D", nrows=43)
test = (
    pd.read_excel(path, usecols="G:H", nrows=2)
    .rename(columns={"User.1": "User"})
)


def simulate_typing(df):
    history = defaultdict(list) 
    current = defaultdict(str) 
    for _, row in df.iterrows():
        user = row["User"]
        action = row["Action"]
        value = row["Value"]

        if action == "Type":
            history[user].append(current[user])
            current[user] += str(value)
        elif action == "Backspace":
            history[user].append(current[user])
            n = int(value)
            current[user] = current[user][:-n]
        elif action == "Undo":
            if history[user]:
                current[user] = history[user].pop()

    return dict(current)


results = simulate_typing(input_df)
result = (
    pd.DataFrame(list(results.items()), columns=["User", "Final Typed"])
    .sort_values("User")
    .reset_index(drop=True)
)

print(result.equals(test))
# True

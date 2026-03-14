import pandas as pd

path = "300-399/373/PQ_Challenge_373.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=24)
test = pd.read_excel(path, usecols="F:J", nrows=2)

def process_user(df):
    stack = []
    for _, row in df.iterrows():
        if row["Action"] == "Type":
            stack.append(row["Value"])
        elif row["Action"] == "Undo" and len(stack) > 0:
            stack.pop()
    return pd.Series({
        "FinalText": "".join(stack),
        "CharactersTyped": (df["Action"] == "Type").sum(),
        "UndoCount": (df["Action"] == "Undo").sum(),
        "FinalLength": len(stack),
    })

result = (
    input
    .sort_values("Step")
    .groupby("User", sort=True)
    .apply(process_user, include_groups=False)
    .reset_index()
)

print(result.equals(test))
# CharactersTyped column has different values than given

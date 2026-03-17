import pandas as pd

path = "300-399/321/321 Teams Max Goal Diff.xlsx"
input_df = pd.read_excel(path, usecols="A:D", nrows=10)
test     = pd.read_excel(path, usecols="F:G", skiprows=1, nrows=4)

result = (
    input_df
    .assign(**{
        "Goal Diff": lambda df: df["Result"]
            .str.split("-")
            .apply(lambda x: abs(int(x[0]) - int(x[1])))
    })
    .nlargest(4, "Goal Diff", keep="all")
    [["Match", "Goal Diff"]]
    .reset_index(drop=True)
)

print(result.equals(test))
# True

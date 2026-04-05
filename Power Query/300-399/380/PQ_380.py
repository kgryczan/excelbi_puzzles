import pandas as pd

path = "300-399/380/PQ_Challenge_380.xlsx"
input = pd.read_excel(path, usecols="A", nrows=24, skiprows=0, header=None)
test = pd.read_excel(path, usecols="C:F", nrows=14, skiprows=0)

input = (
    input[0]
    .str.split(",", expand=True)
    .set_axis(["Category", "Start", "End", "Label"], axis=1)
)
input.columns = input.iloc[0]
input = input[1:]
input["Start"] = pd.to_numeric(input["Start"])
input["End"] = pd.to_numeric(input["End"])

result = (
    input
    .sort_values(["Category", "Start", "End"])
    .assign(
        grp=lambda df: df.groupby("Category")
        .apply(lambda g: (g["Start"] > g["End"].cummax().shift(fill_value=g["End"].iloc[0])).cumsum())
        .reset_index(level=0, drop=True)
    )
    .groupby(["Category", "grp"], as_index=False)
    .agg(
        MergedStart=("Start", "min"),
        MergedEnd=("End", "max"),
        Labels=("Label", lambda x: ", ".join(x))
    )
    .drop(columns="grp")
)

print(result.equals(test))
# True
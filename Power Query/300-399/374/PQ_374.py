import pandas as pd

path = "300-399/374/PQ_Challenge_374.xlsx"
input_df = pd.read_excel(path, usecols="A:D", nrows=20)
test = pd.read_excel(path, usecols="G:J", nrows=12)


def merge_intervals(df):
    df = df.sort_values("StartDate").reset_index(drop=True)
    merged = []
    for _, row in df.iterrows():
        if not merged or row["StartDate"] > merged[-1]["EndDate"]:
            merged.append({"StartDate": row["StartDate"], "EndDate": row["EndDate"]})
        else:
            merged[-1]["EndDate"] = max(merged[-1]["EndDate"], row["EndDate"])
    return pd.DataFrame(merged)


result = (
    input_df
    .groupby(["ResourceID", "Project"], sort=False)
    .apply(merge_intervals, include_groups=False)
    .reset_index(level=[0, 1])
    .reset_index(drop=True)
    [["ResourceID", "Project", "StartDate", "EndDate"]]
    .sort_values(["ResourceID", "Project", "StartDate"])
    .reset_index(drop=True)
)

print(result.equals(test))
# Provided structute not correct. For Theta should be 2 intevals.

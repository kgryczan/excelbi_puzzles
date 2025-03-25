import pandas as pd

path = "680 Team Alignment.xlsx"

input_data = pd.read_excel(path, usecols="A:G", nrows=7)
test_data = pd.read_excel(path, usecols="A:C", skiprows=12, nrows=8)

grouped_columns = {digit: [col for col in input_data.columns if col.endswith(digit)] 
                   for digit in set(col[-1] for col in input_data.columns if col[-1].isdigit())}
for digit, cols in grouped_columns.items():
    if len(cols) > 1:
        input_data[f"united_{digit}"] = input_data[cols].agg(' '.join, axis=1).str.strip()
        input_data.drop(columns=cols, inplace=True)

input_data = (input_data.melt(id_vars=[col for col in input_data.columns if not col.startswith("united_")],
                              value_vars=[col for col in input_data.columns if col.startswith("united_")],
                              value_name="united_value")
              .dropna(subset=["united_value"])
              .query("united_value.str.strip() != ''", engine='python')
              .sort_values(by=["Team", "united_value"])
              .assign(row_number=lambda df: df.groupby("Team").cumcount() + 1)
              .pivot(index="row_number", columns="Team", values="united_value")
              .reset_index(drop=True)[["Mars", "Jupiter", "Saturn"]])

print(input_data.equals(test_data)) # True
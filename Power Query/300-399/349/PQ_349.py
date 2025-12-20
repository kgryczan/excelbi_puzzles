import pandas as pd
import numpy as np
import re

input_path = "Power Query/300-399/349/PQ_Challenge_349.xlsx"

input_df = pd.read_excel(input_path, usecols="A", nrows=70)
test_df = pd.read_excel(input_path, usecols="C:I", nrows=70)
test_df["Middle Name"] = test_df["Middle Name"].fillna("")

def extract_full_name(s):
    match = re.match(r"^[^(]+", s)
    return match.group(0).strip() if match else ""

def extract_duration(s):
    match = re.search(r"\(([^)]+)\)", s)
    return match.group(1) if match else ""

def split_name(full_name):
    parts = full_name.strip().split()
    first = parts[0] if parts else ""
    last = parts[-1] if len(parts) > 1 else ""
    middle = " ".join(parts[1:-1]) if len(parts) > 2 else ""
    return first, middle, last

result = input_df.copy()
result["Presidency #"] = np.arange(1, len(result) + 1)
result["Full Name"] = result["US Presidents"].apply(extract_full_name)
result["Duration"] = result["US Presidents"].apply(extract_duration)

result[["First Name", "Middle Name", "Last Name"]] = result["Full Name"].apply(
    lambda x: pd.Series(split_name(x))
)

result["num_presidencies"] = result.groupby("Full Name").cumcount() + 1

last_name_counts = result.groupby("Last Name")["Full Name"].nunique()
result["Dynasty Flag"] = result["Last Name"].map(lambda x: "Yes" if last_name_counts[x] > 1 else "No")

def term_check(row, prev_row):
    if row["num_presidencies"] == 1:
        return "First Term"
    elif prev_row is not None and prev_row["Full Name"] == row["Full Name"]:
        return "Re-elected (Consecutive)"
    else:
        return "Re-elected (Non-Consecutive)"

result["Term Check"] = [
    term_check(row, result.iloc[i - 1] if i > 0 else None)
    for i, row in result.iterrows()
]

result = result[
    [
        "Presidency #",
        "First Name",
        "Middle Name",
        "Last Name",
        "Duration",
        "Term Check",
        "Dynasty Flag",
    ]
] 
print(result.equals(test_df))

import pandas as pd

path = "300-399/394/PQ_Challenge_394.xlsx"
input = pd.read_excel(path, usecols="A", nrows=26, header=None)
test = pd.read_excel(path, usecols="C:F", nrows=9)

result = (
    input.iloc[:, 0]
    .astype(str)
    .str.split(",", expand=True)
    .pipe(lambda x: x.set_axis(x.iloc[0].astype(str).str.strip(), axis=1).iloc[1:])
    .assign(Marks=lambda x: pd.to_numeric(x["Marks"], errors="coerce"))
    .dropna(subset=["Marks"])
    .loc[lambda x: x["Marks"].eq(x.groupby(["Class", "Subject"])["Marks"].transform("max"))]
    .assign(top_subjects=lambda x: x.groupby(["Class", "StudentID"])["Subject"].transform("count"))
    .loc[lambda x: x["top_subjects"].eq(x.groupby("Class")["top_subjects"].transform("max"))]
    [["StudentID", "Class", "Subject", "Marks"]]
    .reset_index(drop=True)
)

print(result.equals(test))
# True
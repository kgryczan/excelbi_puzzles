import pandas as pd

path = "1000-1099/1032/1032 Marks Calculation.xlsx"
marks = pd.read_excel(path, usecols="A:D", skiprows=1, nrows=28)
expected = pd.read_excel(path, usecols="F:G", skiprows=1, nrows=5)
expected.columns = ["Student_ID", "Final_Score"]


def score(d):
    if len(d) < 5:
        return 0
    core = d.loc[d.Subject_Type.eq("Core"), "Marks"].tolist()
    electives = sorted(d.loc[d.Subject_Type.eq("Elective"), "Marks"], reverse=True)[
        : 5 - len(core)
    ]
    failing = sorted(mark for mark in core if mark < 50)
    for i in range(min(len(failing), len(electives))):
        electives[i] *= 0.9
    return round(sum(core) + sum(electives))


result = (
    marks.groupby("Student_ID", sort=True)
    .apply(score, include_groups=False)
    .rename("Final_Score")
    .reset_index()
)
print(result.equals(expected))

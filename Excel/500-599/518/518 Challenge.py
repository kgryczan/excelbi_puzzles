import pandas as pd
import numpy as np

path = "518 Rank Students.xlsx"
input = pd.read_excel(path, usecols="A:B")
test  = pd.read_excel(path, usecols="C")

grade_levels = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-"]
input['Grades'] = pd.Categorical(input['Grades'], categories=grade_levels, ordered=True)
input["rank"] = np.where(input["Grades"] == "F", np.nan, input["Grades"].rank(ascending=True, method="dense"))

print(input["rank"].equals(test["Answer Expected"])) # True
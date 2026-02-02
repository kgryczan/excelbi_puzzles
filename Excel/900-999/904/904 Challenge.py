import pandas as pd
import numpy as np

path = "Excel/900-999/904/904 Grades.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=21)
test = pd.read_excel(path, usecols="C", nrows=21)

def grade_student(marks):
    if np.sum(np.array(marks) < 60) >= 2:
        return "F"
    avg_top3 = np.mean(sorted(marks, reverse=True)[:3])
    return pd.cut(
        [avg_top3],
        bins=[-np.inf, 60, 70, 80, 90, np.inf],
        labels=["F", "D", "C", "B", "A"],
        right=False
    )[0]

long = (
    input[['Student_ID', 'Subject Marks']]
    .assign(subject_mark=lambda d: d['Subject Marks'].str.split(';\\s*'))
    .explode('subject_mark')
    .dropna(subset=['subject_mark'])
)

long[['Subject', 'Marks']] = long['subject_mark'].str.split(':', n=1, expand=True)
long['Marks'] = long['Marks'].astype(float)

input = (
    long.groupby('Student_ID')
    .apply(lambda g: pd.Series({'Grade': grade_student(g['Marks'].values)}))
    .reset_index()
)

print(input['Grade'].equals(test['Final_Grade']))  # True

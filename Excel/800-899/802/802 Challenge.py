import pandas as pd
import numpy as np
import itertools
import re

path = "800-899/802/802 Conditionals.xlsx"
input_df = pd.read_excel(path, usecols="A:C", nrows=5)
test = pd.read_excel(path, usecols="E", nrows=5).squeeze()

def solve_candidates(df):
    def prep_condition(row):
        cond = row['Conditions']
        cond = re.sub(r'^=', '==', cond)
        cond = re.sub(r'(<=|>=|<|>|==)', f"{row['Group']} \\1 ", cond)
        return cond

    conditions = df.apply(prep_condition, axis=1).tolist()
    rules = " & ".join([f"({c})" for c in conditions])

    groups = df['Group'].tolist()
    candidates = df['Candidates'].tolist()
    grid = pd.DataFrame(list(itertools.product(*candidates)), columns=groups)

    filtered = grid.query(rules)
    return filtered.values.flatten()

input_df['Candidates'] = input_df['Candidates'].apply(lambda x: [float(i.strip()) for i in str(x).split(',')])

result = solve_candidates(input_df)
print(np.all(result == test))

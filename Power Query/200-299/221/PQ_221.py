import pandas as pd
import numpy as np

path = "PQ_Challenge_221.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=20)
test = pd.read_excel(path, usecols="E:J", nrows=20).rename(columns=lambda x: x.replace('.1', ''))
test["Task_Index"] = test["Task_Index"].astype(str)

input['Project_Index'] = (input['Project'].astype('category').cat.codes + 1).astype(np.int64)
input['Task_Index'] = (input['Project_Index'].astype(str) + "." +
                          input.groupby('Project')['Task']
                          .transform(lambda x: (x.astype('category').cat.codes + 1).astype(str)))
input['Activity_Index'] = (input['Task_Index'] + "." +
                              input.groupby(['Project', 'Task'])['Activity']
                              .transform(lambda x: (x.astype('category').cat.codes + 1).astype(str)))

print(input.equals(test))   # True
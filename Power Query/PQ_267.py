import pandas as pd

path = "PQ_Challenge_267.xlsx"
input = pd.read_excel(path, usecols="A", nrows=62)
test = pd.read_excel(path, usecols="C:D", nrows=62)

main = [i for i in range(1, 11) for _ in range(11 - i)][:len(input)]
groups = main + list(range(11, 11 + len(input) - len(main)))

input['groups'] = groups
input['Running Total'] = input.groupby('groups')['Amount'].cumsum()
result = input.drop(columns=['groups'])

print(result['Running Total'].equals(test['Running Total'])) # True
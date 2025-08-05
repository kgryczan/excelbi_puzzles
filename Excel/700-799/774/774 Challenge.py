import pandas as pd

path = "700-799/774/774 Names Having Common Words.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=20, names=["Names"])
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=16, names=["Words", "Names"])\
    .sort_values(["Words", "Names"]).reset_index(drop=True)

common_words = pd.Series(' '.join(input['Names']).split()).value_counts()
common_words = common_words[common_words > 1].index.tolist()

result = pd.DataFrame([(word, name) for word in common_words for name in input['Names'] if word in str(name)],
                      columns=['Words', 'Names'])
result = result.sort_values(['Words', 'Names']).reset_index(drop=True)

print(result.equals(test)) # True


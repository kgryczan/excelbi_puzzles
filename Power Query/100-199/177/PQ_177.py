import pandas as pd
 
input = pd.read_excel("PQ_Challenge_177.xlsx", usecols = "A:F", nrows = 10)
test = pd.read_excel("PQ_Challenge_177.xlsx", usecols = "H:M", nrows = 10)
test.columns = test.columns.str.replace('.1', '')
# replace all Nas with empty string for comparison purposes
test = test.fillna('')

result = input.assign(Result=input.apply(lambda row: "Fail" if any(row[['Marks1', 'Marks2', 'Marks3']] < 40) else "Pass", axis=1),
                      total=input[['Marks1', 'Marks2', 'Marks3']].sum(axis=1)) \
              .assign(average=lambda df: df.groupby('Name')['total'].transform('mean'),
                      rn=lambda df: df.groupby('Name').cumcount() + 1)
aux_rank = result[['Name', 'average']].drop_duplicates() \
                                      .assign(Rank=lambda df: df['average'].rank(ascending=False))
result2 = result.merge(aux_rank, on=['Name', 'average'], how='left') \
                .drop(columns=['Marks1', 'Marks2', 'Marks3', 'average']) \
                .rename(columns={'total': 'Total Marks'})
result2[['Rank', 'Name', 'Classs']] = result2[['Rank', 'Name', 'Classs']].where(result2['rn'] == 1, "")
result2 = result2.drop(columns='rn')
result2 = result2[['Name', 'Classs', 'Subject', 'Total Marks', 'Result', 'Rank']]

print(result2.equals(test)) # True
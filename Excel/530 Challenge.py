import pandas as pd

path = "530 Dates for Max Sales.xlsx"
input = pd.read_excel(path, usecols = "A:I", skiprows = 1)
test  = pd.read_excel(path, usecols = "J:K", skiprows = 1)
 
r1 = input.melt(id_vars=['Name'], value_vars=[col for col in input.columns if 'Date' in col], 
                   var_name='Date_Col', value_name='Date_val')
r2 = input.melt(id_vars=['Name'], value_vars=[col for col in input.columns if 'Amount' in col],
                   var_name='Sales_Col', value_name='Amount_val')

result = pd.concat([r1[["Name", "Date_val"]], r2[["Amount_val"]]], axis=1)
result = result[result.groupby('Name')['Amount_val'].transform(max) == result['Amount_val']]
result['Date_val'] = result['Date_val'].astype(str)
result = result.groupby('Name').agg({'Date_val': lambda x: ', '.join(x), 'Amount_val': 'first'}).reset_index(drop=True)

print(result)

#                              Date_val  Amount_val
# 0                          2006-10-02         716
# 1              2016-07-08, 2022-06-14         886
# 2                          2015-02-27         970
# 3                          2014-06-13         898
# 4  2016-10-15, 2016-05-31, 2002-11-10         913
# 5              2000-10-17, 2018-10-16         656
# 6                          2022-08-02         993
# 7                          2017-04-02         690
# 8                          2015-04-18         684
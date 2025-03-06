import pandas as pd
import numpy as np

path = "667 Pivot Problem.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=21)
test = pd.read_excel(path, usecols="D:J", skiprows=1, nrows=9)
test.update(test.select_dtypes(include=[np.number]).applymap(lambda x: str(int(x)) if not pd.isna(x) else np.NaN))

input['Month-Day'] = input['Date'].dt.strftime('%b')
input['wday'] = input['Date'].dt.strftime('%a')

result = input.drop(columns=['Date']).astype({'Month-Day': 'category', 'wday': 'category'})
result = result.groupby(['Month-Day', 'wday'], observed=False)['Sales'].apply(lambda x: ', '.join(map(str, x))).unstack().reset_index()
result = result[['Month-Day', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']]

month_order = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
result['Month-Day'] = pd.Categorical(result['Month-Day'], categories=month_order, ordered=True)
result = result.sort_values('Month-Day').reset_index(drop=True)
result['Month-Day'] = result['Month-Day'].astype(str)

print(result.equals(test)) # True

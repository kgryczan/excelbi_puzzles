import pandas as pd

path = "200-299/288/PQ_Challenge_288.xlsx"
input1 = pd.read_excel(path, usecols="A:F", skiprows=1, nrows=100)
input2 = pd.read_excel(path, usecols="H:K", skiprows=1, nrows=63)
test = pd.read_excel(path, usecols="M:P", skiprows=1, nrows=12).rename(columns=lambda x: x.replace('.1', ''))
test[['Mar', 'Apr']] = test[['Mar', 'Apr']].applymap(lambda x: str(int(-(-x // 1))) if pd.notnull(x) else x)

xrates = input2.melt(id_vars=input2.columns[0], var_name="Currency", value_name="xrate")
input1['Product'] = input1['Product'].str.replace(' ', '').str.lower()
df = input1.merge(xrates, left_on=['Date', 'Currency'], right_on=[input2.columns[0], 'Currency'])
df['rev'] = (df['Unit_Price'] * df['xrate'] * df['Quantity']).round(2)
df['month'] = pd.to_datetime(df['Date']).dt.strftime('%b')

result = (
    df.groupby(['month', 'Product', 'Country'], as_index=False)['rev'].sum()
    .pivot(index=['Country', 'Product'], columns='month', values='rev')
    .reset_index()[['Country', 'Product', 'Mar', 'Apr']]
    .sort_values(['Country', 'Product'])
)
result[['Mar', 'Apr']] = result[['Mar', 'Apr']].applymap(lambda x: str(int(-(-x // 1))) if pd.notnull(x) else x)
result.columns.name = None

print(result.equals(test))  # True

import pandas as pd
import numpy as np

path = "Power Query/300-399/345/PQ_Challenge_345.xlsx"
input = pd.read_excel(path, usecols="A:G", nrows=31)
test = pd.read_excel(path, usecols="J:O", nrows=7)

input['Region'] = np.where(
    input['Column1'].str.contains("Region"),
    input['Column1'].str.replace("Region: ", "", regex=False),
    np.nan
)
input['Region'] = input['Region'].ffill()
result = input[~input['Column1'].str.contains("Region")].copy()
result['ngroup'] = (result['Column1'] == "Category").cumsum()

env_by_region = []
for (region, ngroup), group in result.groupby(['Region', 'ngroup']):
    group = group.reset_index(drop=True)
    header = group.iloc[0]
    df = group.iloc[1:].copy()
    df.columns = header
    df = df.iloc[:, :-1]
    df['Region'] = region
    df_long = df.melt(id_vars=['Category', 'Region'], var_name='Month', value_name='Value')
    df_long[['Month', 'Type']] = df_long['Month'].str.split('-', expand=True)
    df_wide = df_long.pivot_table(index=['Category', 'Region', 'Month'], columns='Type', values='Value', aggfunc='first').reset_index()
    
    # Month abbreviation to quarter mapping
    month_to_quarter = {
        'Jan': 'Q1', 'Feb': 'Q1', 'Mar': 'Q1',
        'Apr': 'Q2', 'May': 'Q2', 'Jun': 'Q2',
        'Jul': 'Q3', 'Aug': 'Q3', 'Sep': 'Q3',
        'Oct': 'Q4', 'Nov': 'Q4', 'Dec': 'Q4'
    }
    df_wide['Quarter'] = df_wide['Month'].map(month_to_quarter)
    df_wide['Sales'] = pd.to_numeric(df_wide.get('Sales', np.nan), errors='coerce')
    df_wide['Returns'] = pd.to_numeric(df_wide.get('Returns', np.nan), errors='coerce')
    env_by_region.append(df_wide)

env_by_region = pd.concat(env_by_region, ignore_index=True)

def summarise_group(df):
    top_sales = df['Sales'] == df['Sales'].max()
    top_returns = df['Returns'] == df['Returns'].max()
    total_sales = df['Sales'].sum(skipna=True)
    total_returns = df['Returns'].sum(skipna=True)
    max_sold_item = ', '.join(sorted(df.loc[top_sales, 'Category'].unique()))
    max_returned_item = ', '.join(sorted(df.loc[top_returns, 'Category'].unique()))
    return pd.Series({
        'Total_Sales': total_sales,
        'Total_Returns': total_returns,
        'Max_Sold_Item': max_sold_item,
        'Max_Returned_Item': max_returned_item
    })

summary = (
    env_by_region
    .groupby(['Region', 'Quarter'], as_index=False)
    .apply(summarise_group)
    .sort_values(['Region', 'Quarter'], ascending=[False, True])
    .reset_index(drop=True)
)

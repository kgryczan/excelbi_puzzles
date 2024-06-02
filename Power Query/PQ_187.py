import numpy as np
import pandas as pd
from itertools import product

input = pd.read_excel("PQ_Challenge_187.xlsx",  usecols="A:C",  nrows=11)
test = pd.read_excel("PQ_Challenge_187.xlsx", usecols="E:G", nrows=30)
test.columns = test.columns.str.replace('.1', '')
test["Year"] = test["Year"].astype(str)
test['Continent'] = np.where(test['Continent'].isna(), 'NA', test['Continent'])

input['Continent'] = np.where(input['Continent'].isna(), 'NA', input['Continent'])
input['Year'] = input['Year'].astype(str)
continents = sorted(input['Continent'].unique())
years = sorted(input['Year'].unique())
all_combinations = pd.DataFrame(list(product(continents, years)), columns=['Continent', 'Year'])
result1 = all_combinations.merge(input, on=['Continent', 'Year'], how='left').fillna({'Sales': 0})
years = result1['Year'].unique()
empty_row = pd.DataFrame({'Continent': [np.nan], 'Year': [np.nan], 'Sales': [np.nan]})
totals = pd.concat([
    pd.concat([result1[result1['Year'] == year], 
               pd.DataFrame({'Continent': ['TOTAL'], 'Year': [year], 'Sales': [result1[result1['Year'] == year]['Sales'].sum()]}), 
               empty_row]) 
    for year in years
])
grand_total = pd.DataFrame({'Continent': ['GRAND TOTAL'], 'Year': ['2010-2013'], 'Sales': [result1['Sales'].sum()]})
result = pd.concat([totals, grand_total], ignore_index=True)
result = pd.concat([test, result], axis=1)
print(result)

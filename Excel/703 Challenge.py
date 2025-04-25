import pandas as pd
from datetime import timedelta

path = "703 Max_Total_By_Days.xlsx.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=31)
test = pd.read_excel(path, usecols="E:F", skiprows=1, nrows=4).sort_values(by="Names").reset_index(drop=True)

input = input.sort_values(by=["Names", "Date"])
summary = (input.groupby('Names', group_keys=False)
           .apply(lambda group: group.assign(Group=group['Date'].diff().gt(timedelta(days=1)).cumsum()))
           .groupby(['Names', 'Group'], as_index=False)['Quantity'].sum()
           .loc[lambda df: df.groupby('Names')['Quantity'].idxmax()]
           .drop(columns=['Group'])
           .reset_index(drop=True))

print(summary.equals(test)) # True
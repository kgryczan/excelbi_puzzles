import pandas as pd
from pprint import pprint

path = "300-399/332/PQ_Challenge_332.xlsx"
input = pd.read_excel(path, usecols="A:L", nrows=22776)

input['date'] = pd.to_datetime(input['date'])
input['my'] = input['date'].dt.to_period('M').dt.to_timestamp()

res = (
    input
    .groupby(['Category', 'city_name', 'my'], as_index=False)
    .agg(mrp=('MRP', 'sum'), qty=('qty_sold', 'sum'))
    .sort_values(['Category', 'city_name', 'my'])
)
res['mrp_pct'] = res.groupby(['Category', 'city_name'])['mrp'].pct_change()
res['qty_pct'] = res.groupby(['Category', 'city_name'])['qty'].pct_change()
piv = res.pivot(index=['Category', 'city_name'], columns='my', values=['mrp', 'qty', 'mrp_pct', 'qty_pct'])
piv.columns = [f"{col[1].strftime('%m_%Y')}_{col[0]}" for col in piv.columns]
piv = piv.reset_index()

months = ["09", "08", "07", "06"]
cols = ['Category', 'city_name']
vals = ['mrp', 'qty', 'mrp_pct', 'qty_pct']

for m in months:
    for v in vals:
        cols += [c for c in piv.columns if c.startswith(f"{m}_") and c.endswith(f"_{v}")]
final_result = piv[cols]
pprint(final_result)
print(final_result.columns.tolist())
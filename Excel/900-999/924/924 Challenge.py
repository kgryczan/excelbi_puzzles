import pandas as pd
import re

path = "900-999/924/924 Session ID.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=21)
test = pd.read_excel(path, usecols="D", nrows=21)

result = (input.sort_values(['UserID','Timestamp'])
.assign(time_diff=lambda d: d.groupby('UserID')['Timestamp'].diff().dt.total_seconds()/60)
.assign(session_id=lambda d: ((d.time_diff > 20)).groupby(d.UserID).cumsum()+1)
.assign(**{'Answer Expected': lambda d: d.UserID.astype(str) + '-' + d.session_id.astype(str)})
)

print(result['Answer Expected'].equals(test['Answer Expected']))
# > True
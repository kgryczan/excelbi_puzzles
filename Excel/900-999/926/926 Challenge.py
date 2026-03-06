import pandas as pd
import re

path = "900-999/926/926 Conversion to ddhhmmss Format.xlsx"
input = pd.read_excel(path, usecols="A", nrows=23)
test = pd.read_excel(path, usecols="B", nrows=23)

def parse_time(x):
    t = pd.to_timedelta(re.sub(r'(\d+)([dhms])',
                               lambda m: f"{m.group(1)} {'days hours minutes seconds'.split()[ 'dhms'.index(m.group(2)) ]}",
                               x))
    d = t.days
    h = t.seconds // 3600
    m = (t.seconds % 3600) // 60
    s = t.seconds % 60
    return f"{d:02}.{h:02}:{m:02}:{s:02}"

result = input['Data'].apply(parse_time)

print(result.equals(test['Answer Expected']))
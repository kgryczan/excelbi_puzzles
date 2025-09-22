import re
import pandas as pd
from datetime import datetime

path = "800-899/809/809 Extract DOB Age Height.xlsx"
df = pd.read_excel(path, usecols="A", skiprows=1, nrows=8)
test = pd.read_excel(path, usecols="B:D", skiprows=1, nrows=8)

MONTHS = {m: i for i, m in enumerate([
    "January", "February", "March", "April", "May", "June", "July", "August",
    "September", "October", "November", "December"], 1)}

date_pat = re.compile(r"""(?xi)
    (?:(?P<d1>\d{1,2})(?:st|nd|rd|th)?\s+(?P<m1>January|February|March|April|May|June|July|August|September|October|November|December)\s+(?P<y1>\d{2,4}))
    |(?:(?P<m2>\d{1,2})/(?P<d2>\d{1,2})/(?P<y2>\d{2,4}))
    |(?:(?P<y3>\d{4})-(?P<m3>\d{2})-(?P<d3>\d{2}))
""")
age_pat = re.compile(r'(\d{1,3}(?:\.\d+)?)\s*years', re.I)
height_pat = re.compile(r"([4-7])'(\d{1,2})\"")

def norm_year(y): y = int(y); return 1900 + y if 0 <= y <= 24 else (2000 + y if 25 <= y <= 99 else y)
def parse_date(t):
    m = date_pat.search(t)
    if not m: return None
    g = m.groupdict()
    try:
        if g['d1']: return f"{int(g['d1']):02}.{MONTHS[g['m1']]:02}.{norm_year(g['y1'])}"
        if g['m2']: return f"{int(g['d2']):02}.{int(g['m2']):02}.{norm_year(g['y2'])}"
        return f"{int(g['d3']):02}.{int(g['m3']):02}.{int(g['y3'])}"
    except: return None
parse_age = lambda t: int(float(age_pat.search(t).group(1))) if age_pat.search(t) else None
parse_height = lambda t: f"{m.group(1)}'{m.group(2)}\"" if (m := height_pat.search(t)) else None

result = pd.concat([test, pd.DataFrame({
    'Date of Birth': df['String'].map(parse_date),
    'Age': df['String'].map(parse_age),
    'Height': df['String'].map(parse_height)
})], axis=1)
print(result)

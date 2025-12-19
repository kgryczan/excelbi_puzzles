import pandas as pd

path = "Excel/800-899/873/873 Smaller Angle Between Clock Hands.xlsx"
input = pd.read_excel(path, usecols="A", nrows=51)
test = pd.read_excel(path, usecols="B", nrows=51)

def angle(h, m):
    d = abs((30*h + 0.5*m) - 6*m)
    return min(d, 360-d)

input['h'] = input['Time'].apply(lambda t: t.hour%12)
input['m'] = input['Time'].apply(lambda t: t.minute)
input['Answer Expected'] = input.apply(lambda r: angle(r['h'], r['m']), axis=1)

print(input['Answer Expected'].equals(test['Answer Expected']))
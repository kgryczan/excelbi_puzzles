import pandas as pd

test = pd.read_excel('422 Leap Years in Julian and Gregorian.xlsx', sheet_name='Sheet1', usecols="A", nrows=27)

years = pd.DataFrame({'range': range(1901, 10000)})

def is_greg_leap(year):
    if year % 4 == 0 and not year % 100 == 0:
        return True
    elif year % 100 == 0 and year % 400 == 0:
        return True
    else:
        return False

def is_revjul_leap(year):
    if year % 4 == 0 and not year % 100 == 0:
        return True
    elif year % 100 == 0 and year % 900 in [200, 600]:
        return True
    else:
        return False

leap_years = years.assign(greg_leap=years['range'].apply(is_greg_leap),
                          revjul_leap=years['range'].apply(is_revjul_leap))
leap_years = leap_years[leap_years['greg_leap'] != leap_years['revjul_leap']]
leap_years = leap_years[['range']].reset_index(drop=True)   

print(leap_years["range"].equals(test["Expected Answer"])) # True
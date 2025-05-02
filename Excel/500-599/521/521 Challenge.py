import pandas as pd
import datetime
import numpy as np

path = "521 Unique Digits in Dates.xlsx"
test = pd.read_excel(path)

dates = np.arange(np.datetime64("1999-01-01"), 
                  np.datetime64("2999-12-31"), 
                  np.timedelta64(1, 'D'))
dates2 = pd.DataFrame({"Dates": dates})
dates2 = dates2[dates2["Dates"]\
                .astype(str)\
                .str.replace("-", "")\
                .apply(lambda x: len(set(x)) == 8)]\
                .astype(str)\
                .reset_index(drop=True)

print(dates2.equals(test))  # True


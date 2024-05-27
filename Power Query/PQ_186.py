import pandas as pd
import numpy as np

input1 = pd.read_excel("PQ_Challenge_186.xlsx", usecols="A")
input2 = pd.read_excel("PQ_Challenge_186.xlsx",  usecols="C:D", nrows=6)
test = pd.read_excel("PQ_Challenge_186.xlsx",  usecols="F:H", 
                     names=["Calendar Date", "Delivery Date", "Vendor"])
input1["Calendar Date"] = pd.to_datetime(input1["Calendar Date"])
input2["Delivery Date"] = pd.to_datetime(input2["Delivery Date"])
input2['preceding_date'] = input2['Delivery Date'] - pd.Timedelta(days=1)
input2['following_date'] = input2['Delivery Date'] + pd.Timedelta(days=1)
input2['date'] = input2['Delivery Date']
marked_dates = input2.melt(id_vars=['Vendor', 'date'], 
                           value_vars=['preceding_date', 'Delivery Date', 'following_date'],
                           var_name='type', value_name='marked_date').\
                            sort_values('marked_date').\
                                reset_index(drop=True)
marked_dates['type'] = pd.Categorical(marked_dates['type'], 
                                      categories=['preceding_date', 'following_date', 'Delivery Date'], 
                                      ordered=True)
calendar_with_marks = input1.merge(marked_dates, 
                                      left_on='Calendar Date',
                                      right_on='marked_date', 
                                      how='left')
calendar_with_marks['marked'] = ~calendar_with_marks['Vendor'].isna()
calendar_with_marks['important'] = calendar_with_marks.\
    groupby('Calendar Date')['type'].transform(lambda x: x == x.max())
calendar_with_marks = calendar_with_marks[calendar_with_marks['type'].isna() |\
                                           calendar_with_marks['important']].reset_index(drop=True)
calendar_with_marks = calendar_with_marks[["Calendar Date", "date", "Vendor"]]
calendar_with_marks.columns = test.columns

print(calendar_with_marks.equals(test)) # True

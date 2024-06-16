import pandas as pd

path = 'PQ_Challenge_192.xlsx'
input = pd.read_excel(path, usecols="A:E", nrows = 13)
test = pd.read_excel(path, usecols="G:J", nrows = 5)
test.columns = test.columns.str.replace(r'\.\d+', '', regex=True)

def count_workdays(from_date, to_date):
    from datetime import datetime, timedelta
    count = 0
    while from_date <= to_date:
        if from_date.weekday() < 5:
            count += 1
        from_date += timedelta(days=1)
    return count

result = input.copy()
result = result.dropna(how='all').fillna(method='ffill')
result.columns = ['Project', 'Phase', 'Scenario', 'From Date', 'To Date']
result = result.pivot_table(index=['Project', 'Phase'], columns='Scenario', values=['From Date', 'To Date'], aggfunc='first')
result['Schedule Performance'] = result.apply(lambda x: 'Overrun' if x['To Date']['Actual'] > x['To Date']['Plan'] else 'Underrun' if x['To Date']['Actual'] < x['To Date']['Plan'] else 'On time', axis=1)
result['Actual Workdays'] = result.apply(lambda x: count_workdays(x['From Date']['Plan'], x['To Date']['Actual']), axis=1)
result['Plan Workdays'] = result.apply(lambda x: count_workdays(x['From Date']['Plan'], x['To Date']['Plan']), axis=1)
result = result[['Schedule Performance', 'Actual Workdays', 'Plan Workdays']]
result.columns = result.columns.droplevel(1)
result['Cost Performance'] = result.apply(lambda x: 'Overrun' if x['Actual Workdays'] > x['Plan Workdays'] else 'Underrun' if x['Actual Workdays'] < x['Plan Workdays'] else 'At Cost', axis=1)
# remove columns actual workdays and plan workdays  
result = result.drop(columns=['Actual Workdays', 'Plan Workdays'])

print(result)
print(test)
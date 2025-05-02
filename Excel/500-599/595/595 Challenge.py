import pandas as pd
import calendar

path = "595 List Weekdays Saturdays and Sundays and Total.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=3)
test = pd.read_excel(path, usecols="D:G", nrows=13).rename(columns=lambda x: x.split('.')[0]).fillna('')

def get_day_counts(year, month):
    month_calendar = calendar.monthcalendar(year, month)
    counts = [sum(1 for week in month_calendar if week[i] != 0) for i in range(7)]
    total_days = sum(counts)
    return [
        {'Year': year, 'Month': month, 'Type': 'Weekdays', 'Days': sum(counts[:5])},
        {'Year': year, 'Month': month, 'Type': 'Saturdays', 'Days': counts[5]},
        {'Year': year, 'Month': month, 'Type': 'Sundays', 'Days': counts[6]},
        {'Year': 'Total:', 'Month': '', 'Type': '', 'Days': total_days}
    ]

result = pd.DataFrame([day for _, row in input.iterrows() for day in get_day_counts(row['Year'], row['Month'])])

print(result.equals(test)) # True
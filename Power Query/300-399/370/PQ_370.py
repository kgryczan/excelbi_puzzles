import pandas as pd
from datetime import datetime
import numpy as np

path = "Power Query/300-399/370/PQ_Challenge_370.xlsx"
input = pd.read_excel(path, usecols="A:D", skiprows=0, nrows=20)
test = pd.read_excel(path,  usecols="F:K", skiprows=0, nrows=20).rename(columns=lambda col: col.replace('.1', ''))

start_date = datetime(2024, 1, 1)

result = (
    input
    .sort_values(['Department', 'Referral Date', 'Patient ID'])
    .groupby('Department', group_keys=False)
    .apply(lambda g: g.assign(
        position=np.arange(1, len(g) + 1),
        forecast_month=(np.arange(1, len(g) + 1) + 1) // 2
    ))
    .assign(
        days_since_start=lambda x: (x['Referral Date'] - start_date).dt.days,
        reporting_period=lambda x: x['days_since_start'] // 30 + 1,
        target_date_days=lambda x: np.select(
            [
                x['forecast_month'] == 1,
                (x['reporting_period'] < x['forecast_month']) & (x['reporting_period'] == 1),
                (x['reporting_period'] < x['forecast_month']) & (x['reporting_period'] >= 2),
                x['reporting_period'] == x['forecast_month']
            ],
            [
                x['days_since_start'],
                (x['forecast_month'] - 1) * 30 - 1,
                (x['forecast_month'] - 1) * 30,
                x['days_since_start']
            ],
            (x['forecast_month'] - 1) * 30
        ),
        wait_days=lambda x: x['target_date_days'] - x['days_since_start'],
        sla_status=lambda x: np.where(x['wait_days'] > x['Target Days (SLA)'], 'Breach', 'Within SLA')
    )
    .sort_values(['Department', 'Referral Date', 'Patient ID'])
    [['Patient ID', 'Department', 'Referral Date', 'forecast_month', 'wait_days', 'sla_status']]
    .rename(columns={
        'forecast_month': 'Forecasted Month',
        'wait_days': 'Wait Days',
        'sla_status': 'SLA Status'
    })
    .reset_index(drop=True)
)
print(result.equals(test))

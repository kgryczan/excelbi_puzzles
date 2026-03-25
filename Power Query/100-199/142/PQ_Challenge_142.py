import pandas as pd

input_data = pd.read_excel("PQ_Challenge_142.xlsx", usecols="A:C", nrows=4)
input_data.columns = [c.strip().lower().replace(" ", "_") for c in input_data.columns]
test = pd.read_excel("PQ_Challenge_142.xlsx", usecols="E:F", nrows=49)

intervals = list(zip(pd.to_datetime(input_data["start_time"]), pd.to_datetime(input_data["end_time"])))
starts = pd.date_range("1899-12-31 09:00:00", "1899-12-31 20:45:00", freq="15min")
ends = pd.date_range("1899-12-31 09:14:59", "1899-12-31 20:59:59", freq="15min")

rows = []
for start, end in zip(starts, ends):
    count = sum((start <= e) and (end >= s) for s, e in intervals)
    rows.append({
        "Time": f"{start.strftime('%I:%M:%S %p')} - {end.strftime('%I:%M:%S %p')}",
        "Count": count,
    })

result = pd.DataFrame(rows)
print(result.equals(test))

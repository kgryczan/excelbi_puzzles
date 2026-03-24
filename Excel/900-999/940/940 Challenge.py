import heapq
import pandas as pd

path = "900-999/940/940 Server Allocation.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=21)
test = pd.read_excel(path, usecols="D", nrows=21)

in_use, free = [], []
next_server, assigned = 1, []

for _, row in input.iterrows():
    start, end = row["Start_Time"], row["End_Time"]
    while in_use and in_use[0][0] <= start:
        _, s = heapq.heappop(in_use)
        heapq.heappush(free, s)
    if free:
        s = heapq.heappop(free)
    else:
        s, next_server = next_server, next_server + 1
    heapq.heappush(in_use, (end, s))
    assigned.append(f"Server {s}")

result = pd.DataFrame({"Answer Expected": assigned})
print(result.equals(test))
# True

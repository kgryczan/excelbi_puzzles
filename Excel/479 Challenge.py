import pandas as pd
import time

path = "479 Recaman Sequence.xlsx"
test = pd.read_excel(path)

def recaman_sequence(n):
    recaman = [0] * n
    seen = set()
    seen.add(0)

    for i in range(1, n):
        next_value = recaman[i - 1] - i
        if next_value > 0 and next_value not in seen:
            recaman[i] = next_value
        else:
            next_value = recaman[i - 1] + i
            recaman[i] = next_value
        seen.add(recaman[i])

    return recaman

start_time = time.time()
sequence = recaman_sequence(10000)
end_time = time.time()
print(f"Time taken: {end_time - start_time} seconds")
# Time taken: 0.0019996166229248047 seconds

print(all(sequence[i] == test["Answer Expected"][i] for i in range(len(sequence))))
# True
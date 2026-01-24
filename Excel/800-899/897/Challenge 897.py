import pandas as pd

path = "Excel/800-899/897/897 Special Score.xlsx"
input_df = pd.read_excel(path, usecols="A:B", nrows=10)
test_df = pd.read_excel(path, usecols="C", nrows=10)

def calc_score(x):
    x = str(x)
    if len(x) < 3:
        return 0
    return sum(
        int(x[i] > x[i+1] and x[i+2] > x[i+1]) +
        2 * int(x[i] < x[i+1] and x[i+2] < x[i+1])
        for i in range(len(x) - 2)
    )

def seq_range(start, end):
    return list(range(int(start), int(end) + 1))

result = input_df.apply(lambda row: sum(calc_score(x) for x in seq_range(row['Range Start'], row['Range End'])), axis=1)
result_df = pd.DataFrame({'Answer Expected': result})

print(result_df.equals(test_df))
# True
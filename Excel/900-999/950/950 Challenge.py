import pandas as pd

path = "900-999/950/950 Containers Allotment.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=21)
test = pd.read_excel(path, usecols="C", nrows=21)

def assign_containers(sizes, capacity=100):
    bins = []
    def place(x):
        for i, used in enumerate(bins):
            if used + x <= capacity:
                bins[i] += x
                return f"C{i+1}"
        bins.append(x)
        return f"C{len(bins)}"
    return [place(x) for x in sizes]

sizes = input['Size'].tolist()
result = assign_containers(sizes)

print(result == test['Answer Expected'].tolist())
# Output: True
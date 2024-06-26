import pandas as pd

path = "486 Create Integer Intervals.xlsx"
input = pd.read_excel(path, usecols="A")
test = pd.read_excel(path, usecols="B")

def group_consecutive(number_string):
    numbers = [int(num) for num in number_string.split(",")]
    numbers.sort()
    ranges = []
    start = end = numbers[0]
    
    for i in range(1, len(numbers)):
        if numbers[i] - numbers[i-1] == 1:
            end = numbers[i]
        else:
            if start == end:
                ranges.append(str(start))
            else:
                ranges.append(f"{start}-{end}")
            start = end = numbers[i]
    
    if start == end:
        ranges.append(str(start))
    else:
        ranges.append(f"{start}-{end}")
    return ", ".join(ranges)

result = input.copy()
result["Answer Expected"] = result["Problem"].map(group_consecutive)

print(result["Answer Expected"].equals(test["Answer Expected"])) # True
import pandas as pd
    
path = "900-999/969/969 Warmer Days Ahead.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=21, skiprows=0)
test = pd.read_excel(path, usecols="C:C", nrows=21, skiprows=0)

def wait_warmer(temp):
    answer = [0] * len(temp)
    stack = []
    for today, value in enumerate(temp):
        while stack and value > temp[stack[-1]]:
            day = stack.pop()
            answer[day] = today - day
        stack.append(today)
    return answer

result = wait_warmer(input["Temperature"])
print(result == test['Answer Expected'].tolist())
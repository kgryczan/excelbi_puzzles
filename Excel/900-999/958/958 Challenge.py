import pandas as pd

path = "900-999/958/958 Wordle.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=11, skiprows=0)
test = pd.read_excel(path, usecols="C", nrows=11, skiprows=0)

def score_word(secret: str, guess: str) -> str:
    result = ["G" if s == g else "B" for s, g in zip(secret, guess)]
    used = [s == g for s, g in zip(secret, guess)]
    for i, g in enumerate(guess):
        if result[i] == "B":
            for j, s in enumerate(secret):
                if not used[j] and g == s:
                    result[i] = "Y"
                    used[j] = True
                    break

    return "".join(result)

input["Score"] = input.apply(lambda row: score_word(row["Target Word"], row["Guess Word"]), axis=1)
print(input['Score'].equals(test['Answer Expected']))
# True
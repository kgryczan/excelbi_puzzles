import pandas as pd

input = pd.read_excel("425 Hex Color Blending.xlsx",usecols="A:B", nrows = 10)
test = pd.read_excel("425 Hex Color Blending.xlsx", usecols="C", nrows = 10)

def split_and_convert_colors(color):
    return [int(c) for c in color.split(", ")]

input['Color1'] = input['Color1'].apply(split_and_convert_colors)
input['Color2'] = input['Color2'].apply(split_and_convert_colors)
input['FinalColor'] = input.apply(lambda row: [(c1 + c2 + 1) // 2 for c1, c2 in zip(row['Color1'], row['Color2'])], axis=1)
input['Answer Expected'] = input['FinalColor'].apply(lambda color: '#' + ''.join([hex(c)[2:].zfill(2).upper() for c in color]))
input = input.drop(columns=['Color1', 'Color2', 'FinalColor'])

print(input.equals(test)) # True

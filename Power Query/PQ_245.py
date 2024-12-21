import pandas as pd
import numpy as np

path = "PQ_Challenge_245.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=6)
test = pd.read_excel(path, usecols="D:G", nrows=9).fillna('')

input = input.assign(Subjects=input['Subjects'].str.split(', ')).explode('Subjects')
r1 = input.groupby('Subjects')['Names'].apply(lambda x: sorted(x.tolist())).reset_index()
weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri"]
weekday_n = len(weekdays)
subjects_list = r1.set_index('Subjects')['Names'].apply(lambda x: np.array(x)).to_dict()
longest_subject = max(map(len, subjects_list.values()))
first_col = [""] * (longest_subject * -(-weekday_n // longest_subject))
subjects = {k: np.tile(v, -(-weekday_n // len(v))) for k, v in subjects_list.items()}

df = pd.DataFrame({
    'Days': weekdays + [f"Backup{i}" for i in range(1, len(first_col) - weekday_n + 1)],
    **{subject: np.concatenate([names, [''] * (len(first_col) - len(names))]) for subject, names in subjects.items()}
})

print(df.equals(test)) # True
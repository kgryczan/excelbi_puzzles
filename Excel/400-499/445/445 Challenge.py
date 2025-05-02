import pandas as pd

df = pd.DataFrame({
    'Eiffel': ['|', '/\\', '00',
               'XX', 'XX', 'XX',
               'XXXX', 'XXXX', 'XXXX',
               'XXXXXXX', 'XXXXXXX', 'XXXXXXX',
               'XXXXXXXXX', 'XXXXXXXXX', 'XXXXXXXXX',
               'XXXX____XXXX', 'XXXX________XXXX',
               'XXXXXXXXXXXXXXXXXX',
               'XXXXX_____________XXXXX',
               'XXXXXX_______________XXXXXX']
})

print(df.to_markdown(stralign = 'center'))
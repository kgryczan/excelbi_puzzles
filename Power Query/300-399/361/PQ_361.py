import pandas as pd

path = "Power Query/300-399/361/PQ_Challenge_361.xlsx"
input_data = pd.read_excel(path, sheet_name="Sheet1", usecols="A", nrows=21)
test = pd.read_excel(path, sheet_name="Sheet1", usecols="C:F", nrows=5)

result = (
    input_data['Log Data']
    .str.replace('Status:', '', regex=False)
    .str.extract(
        r'#(?P<Ticket_ID>\d+-\d+)#\s*'           
        r'\((?P<Priority>[A-Z]+)\)\s*'          
        r'Service:(?P<Service>[^>]+?)'          
        r'\s*>>\s*'                             
        r'(?P<Status>\w+)'                      
    )
    .assign(Service=lambda x: x['Service'].str.strip())
    .query("Status != 'Closed' and Status != 'Resolved'")
    .reset_index(drop=True)
)

print(result.equals(test))  # True
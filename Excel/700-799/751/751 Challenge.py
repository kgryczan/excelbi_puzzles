import pandas as pd

path = "700-799/751/751 Levels of Managers.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=10)
test = pd.read_excel(path, usecols="D:H", skiprows=1, nrows=10).rename(columns=lambda col: col.split('.')[0] if '.' in col else col)

mgr_map = input.set_index('Employee')['Manager'].to_dict()

def get_manager_chain(emp):
    chain = []
    while True:
        mgr = mgr_map.get(emp)
        if mgr is None:
            break
        chain.append(mgr)
        emp = mgr
    return chain

hierarchy = pd.DataFrame({
    'Employee': input['Employee'],
    'Managers': input['Employee'].apply(get_manager_chain)
})
result = (hierarchy.explode('Managers')
          .assign(RowNumber=lambda df: df.groupby('Employee').cumcount() + 1)
          .query("RowNumber == 1 or Managers.notna()")
          .pivot(index='Employee', columns='RowNumber', values='Managers')
          .reset_index())
result.columns = ['Employee'] + [f'L{col} Manager' for col in result.columns[1:]]

print(result.equals(test)) # True
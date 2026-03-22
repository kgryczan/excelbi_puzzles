import pandas as pd

path = "300-399/376/PQ_Challenge_376.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=20)
test     = pd.read_excel(path, usecols="F:H", nrows=20).rename(columns=lambda c: c.replace(".1", ""))

parent = dict(zip(input["CommitID"], input["ParentCommitID"]))

def get_path(commit_id):
    """Walk up parent chain from commit_id to root, return ' > '-joined string."""
    path = [commit_id]
    while pd.notna(parent.get(path[0])):
        path.insert(0, parent[path[0]])
    return " > ".join(path)

result = (
    input[["CommitID", "Author"]]
    .assign(FullPath=input["CommitID"].map(get_path))
    .reset_index(drop=True)
)

print(result.equals(test))
# True

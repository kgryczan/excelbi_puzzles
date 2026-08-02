import pandas as pd

p = "400-499/413/PQ_Challenge_413.xlsx"
data = pd.read_excel(p, usecols="A:C", nrows=24)
expected = pd.read_excel(p, usecols="E:G", nrows=8)
expected.columns = ["Table", "LoopID", "Seating Order"]


def find_loops(group):
    table, to = group.Table.iloc[0], dict(zip(group.Guest, group.Preference))
    order = {guest: i for i, guest in enumerate(to)}

    def cycle(path):
        nxt = to[path[-1]]
        return cycle(path + [nxt]) if nxt not in path else path[path.index(nxt) :]

    def normalize(loop):
        i = min(range(len(loop)), key=lambda j: order[loop[j]])
        return loop[i:] + loop[:i]

    loops = dict.fromkeys(tuple(normalize(cycle([guest]))) for guest in to)
    return pd.DataFrame(
        [(table, f"{table}{i}", " > ".join(loop)) for i, loop in enumerate(loops, 1)],
        columns=expected.columns,
    )


result = pd.concat(
    (find_loops(g) for _, g in data.groupby("Table", sort=True)), ignore_index=True
)
print(result.equals(expected))

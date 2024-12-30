from pprint import pprint


with open("../../input/2024/25.txt") as f:
    data = f.read().split("\n\n")

keys = []
locks = []

w = 0
h = 0

for schema in data:

    grid = list(map(lambda x: list(x), schema.split("\n")))
    w = len(grid[0])
    h = len(grid)
    rows = [-1 for _ in grid[0]]
    for i in range(len(grid[0])):
        for row in grid:
            if row[i] == "#":
                rows[i] += 1
    match grid[0][0]:
        case "#":
            locks.append(rows)
        case ".":
            keys.append(rows)


good_comb = []

for key in keys:
    for lock in locks:
        if all(key[i] + lock[i] <= h - 2 for i in range(w)):
            good_comb.append(
                (
                    lock,
                    key,
                )
            )

pprint(len(good_comb))

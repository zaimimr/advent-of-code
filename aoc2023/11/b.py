import numpy as np

data = np.array([list(line) for line in open("input").read().splitlines()])
idx = 1
galaxies = {}
expand_rate = 1_000_000

def check_empty(r):
    return sum([z != "." for z in r]) == 0

for i, row in enumerate(data):
    for j, col in enumerate(row):
        if col == "#":
            empty = [0, 0]
            for y in range(i, 0, -1):
                if check_empty(data[y - 1, :]):
                    empty[0] += 1
            for x in range(j, 0, -1):
                if check_empty(data[:, x - 1]):
                    empty[1] += 1
            _0 = i + empty[0] * (expand_rate - 1)
            _1 = j + empty[1] * (expand_rate - 1)
            galaxies[idx] = (_0, _1)
            idx += 1


distances = {}
for i in galaxies:
    for j in galaxies:
        if i != j and (i, j) not in distances and (j, i) not in distances:
            distances[(i, j)] = abs(galaxies[i][0] - galaxies[j][0]) + abs(
                galaxies[i][1] - galaxies[j][1]
            )
print("Total distance:", sum(distances.values()))

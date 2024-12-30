import numpy as np
from pprint import pprint

# increase print size for numpy arrays
np.set_printoptions(threshold=np.inf)

data = np.array([list(line) for line in open("ex").read().splitlines()])
for _ in range(2):
    data = data.transpose()
    added = 0
    for idx, col in enumerate(data[:]):
        if sum([i != "." for i in col]) == 0:
            for i in range(1):
                data = np.insert(data, idx+added, ".", axis=0)
                added += 1

idx = 1
galaxies = {}
# enumerate through array and make all "#" into idx
for i, row in enumerate(data):
    for j, col in enumerate(row):
        if col == "#":
            data[i][j] = idx
            galaxies[idx] = (i, j)
            idx += 1
# find distance between all combinations of galaxies
distances = {}
for i in galaxies:
    for j in galaxies:
        if i != j and (i, j) not in distances and (j, i) not in distances:
            distances[(i, j)] = (abs(galaxies[i][0] - galaxies[j][0]) + abs(galaxies[i][1] - galaxies[j][1]))
for col in data:
    print(''.join(col))

print("Galaxies:", galaxies)

print("Total galaxies:", len(distances))
print("Total distance:", sum(distances.values()))
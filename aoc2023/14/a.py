from pprint import pprint
import numpy as np

data = np.array([list(line) for line in open("ex").read().splitlines()])


def roll_north(data):
    for row in range(len(data)):
        if row == 0:
            continue
        for col in range(len(data[row])):
            y = row
            while data[row][col] == "O" and y > 0 and data[y-1][col] == ".":
                y -= 1
            if y != row:
                data[row][col] = "."
                data[y][col] = "O"
    return data


# data = roll_north(data)

def cycle(data):
    for _ in range(4):
        data = roll_north(data)
        data = np.rot90(data, 1, (1, 0))

    return data

for iternation in range(1_000_000_000):
    data = cycle(data)

pprint((["".join(row) for row in data]))

data = np.flip(data)

print("part1", sum([sum([1 for col in row if col == "O"])*(idx+1) for idx, row in enumerate(data)]))
            
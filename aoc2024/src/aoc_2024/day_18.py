from pprint import pprint
from collections import deque

size = 70


with open("../../input/2024/18.txt") as f:
    data = list(
        map(lambda x: list(map(lambda nr: int(nr), x.split(","))), f.read().split("\n"))
    )


def bfs_shortest_path(grid, start, end, size):
    queue = deque([[start]])
    seen = set([start])

    while queue:
        path = queue.popleft()
        node = path[-1]

        if node == end:
            return path

        for x, y in ((0, 1), (0, -1), (1, 0), (-1, 0)):
            new_x, new_y = node[0] + x, node[1] + y
            new_node = (new_x, new_y)

            if (
                0 <= new_x <= size
                and 0 <= new_y <= size
                and grid[new_y][new_x] == "."
                and new_node not in seen
            ):
                queue.append([*path, new_node])
                seen.add(new_node)

    return None


# for chunk in range(1024, len(data)):
min_chunk = 1024
max_chunk = len(data)

while min_chunk < max_chunk:
    chunk = (min_chunk + max_chunk) // 2

    grid = [
        ["#" if [x, y] in data[:chunk] else "." for x in range(size + 1)]
        for y in range(size + 1)
    ]

    start = (0, 0)
    end = (size, size)
    path = bfs_shortest_path(grid, start, end, size)
    if path is None:
        max_chunk = chunk - 1
    else:
        min_chunk = chunk + 1


chunk = max_chunk + 1
grid = [
    ["#" if [x, y] in data[:chunk] else "." for x in range(size + 1)]
    for y in range(size + 1)
]
start = (0, 0)
end = (size, size)
path = bfs_shortest_path(grid, start, end, size)
if path is None:
    print(data[chunk - 1])

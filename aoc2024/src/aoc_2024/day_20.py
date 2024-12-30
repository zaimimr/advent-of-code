from dataclasses import dataclass


@dataclass
class Pos:
    x: int
    y: int

    def copy(self):
        return Pos(self.x, self.y)

    def __hash__(self) -> int:
        return hash((self.x, self.y))

    def __str__(self) -> str:
        return f"({self.x}, {self.y})"

    def __repr__(self) -> str:
        return self.__str__()

    def __sub__(self, other):
        return abs(self.x - other.x) + abs(self.y - other.y)


def index_2d(grid, value):
    for i, x in enumerate(grid):
        if value in x:
            return Pos(x.index(value), i)


with open("../../input/2024/20.txt") as f:
    grid = list(map(lambda x: list(x), f.read().split("\n")))


start_pos = index_2d(grid, "S")
end_pos = index_2d(grid, "E")


def race(grid, start, end):
    visited = {}
    stack = [start]
    counter = 0
    while stack:
        pos = stack.pop()
        if pos in visited:
            continue
        visited[pos] = counter
        counter += 1
        if pos == end:
            return visited
        x, y = pos.x, pos.y
        for dx, dy in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
            new_pos = Pos(x + dx, y + dy)
            if (
                0 <= new_pos.x < len(grid[0])
                and 0 <= new_pos.y < len(grid)
                and grid[new_pos.y][new_pos.x] != "#"
            ):
                stack.append(new_pos)
    return None


def find_shortcut(visited_positions, distance):
    checked = {}
    for p1, d1 in visited_positions.items():
        for p2, d2 in visited_positions.items():
            dist = abs(p1 - p2)
            if dist > distance:
                continue
            cut = abs(d1 - d2) - dist
            if (p2, p1) in checked or (p1, p2) in checked:
                continue
            checked[(p1, p2)] = cut
    result = {}
    for v in checked.values():
        if v > 0:
            result[v] = result.get(v, 0) + 1
    res = 0
    for k, v in result.items():
        if k >= 100:
            res += v
    return res


visited_positions = race(grid, start_pos, end_pos)
p1 = find_shortcut(visited_positions, 2)
p2 = find_shortcut(visited_positions, 20)
print(p1, p2)

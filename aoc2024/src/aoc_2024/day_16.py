# part 2: 529

from dataclasses import dataclass
import enum



class Direction(enum.Enum):
    North = 0
    East = 1
    South = 2
    West = 3


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


@dataclass
class Bot:
    position: Pos
    facing: Direction
    total_cost: int = 0

    def copy(self):
        return Bot(self.position.copy(), self.facing, self.total_cost)

    def __str__(self) -> str:
        return f"Bot({self.position}, {self.facing}, {self.total_cost})"

    def __repr__(self) -> str:
        return self.__str__()

    def __hash__(self):
        return hash((self.position, self.facing))


def index_2d(grid, value):
    for i, x in enumerate(grid):
        if value in x:
            return Pos(x.index(value), i)


with open("../../input/2024/16.txt") as f:
    data = list(map(lambda x: list(x), f.read().split("\n")))


start_pos = index_2d(data, "S")
end_pos = index_2d(data, "E")


start_robot = Bot(start_pos, Direction.East)
cost_forward = 1
cost_turn = 1000

grid_cost = [
    [
        dict(
            [(direction, {"cost": float("inf"), "prev": {}}) for direction in Direction]
        )
        for _ in range(len(data[0]))
    ]
    for _ in range(len(data))
]


def turn(bot: Bot, left: bool):
    bot.total_cost += cost_turn
    if left:
        bot.facing = Direction((bot.facing.value - 1) % 4)
    else:
        bot.facing = Direction((bot.facing.value + 1) % 4)


def move(grid, bot: Bot):
    bot.total_cost += cost_forward
    match bot.facing:
        case Direction.North:
            if grid[bot.position.y - 1][bot.position.x] != "#":
                bot.position.y -= 1
        case Direction.East:
            if grid[bot.position.y][bot.position.x + 1] != "#":
                bot.position.x += 1
        case Direction.South:
            if grid[bot.position.y + 1][bot.position.x] != "#":
                bot.position.y += 1
        case Direction.West:
            if grid[bot.position.y][bot.position.x - 1] != "#":
                bot.position.x -= 1


def check(bot, grid_cost, queue, prev_bot):
    if bot.total_cost < grid_cost[bot.position.y][bot.position.x][bot.facing]["cost"]:
        grid_cost[bot.position.y][bot.position.x][bot.facing]["cost"] = bot.total_cost
        grid_cost[bot.position.y][bot.position.x][bot.facing]["prev"] = {prev_bot: 1}

        queue.append(bot)
        queue.sort(key=lambda x: x.total_cost)

    elif bot.total_cost == grid_cost[bot.position.y][bot.position.x][bot.facing]["cost"]:
        prev_dict = grid_cost[bot.position.y][bot.position.x][bot.facing]["prev"]
        if prev_bot in prev_dict:
            prev_dict[prev_bot] += 1
        else:
            prev_dict[prev_bot] = 1


def dijkstra(grid, start, end):
    queue = [start]

    grid_cost[start.position.y][start.position.x][Direction.East]["cost"] = 0
    while queue:
        bot = queue.pop(0)

        if bot.position == end:
            return bot

        forward_bot = bot.copy()
        move(grid, forward_bot)
        check(forward_bot, grid_cost, queue, prev_bot=bot)

        left_bot = bot.copy()
        turn(left_bot, True)
        check(left_bot, grid_cost, queue, prev_bot=bot)

        right_bot = bot.copy()
        turn(right_bot, False)
        check(right_bot, grid_cost, queue, prev_bot=bot)

    return None


solution = dijkstra(data, start_robot, end_pos)

if solution is not None:
    queue = [[solution]]
    seen = {}
    seen[(solution, solution)] = 1

    while queue:
        item = queue.pop(0)
        pos = item[-1]
        solution_dict = grid_cost[pos.position.y][pos.position.x]
        get_all_in_a_with_min_a = solution_dict[pos.facing]["prev"]
        for new in get_all_in_a_with_min_a:
            if (pos, new) not in seen:
                queue.append([*item, new])
                seen[(pos, new)] = 1
            else:
                seen[(pos, new)] += 1

if False:
    for pos in list(seen):
        data[pos[1].position.y][pos[1].position.x] = "O"

    for row in data:
        print("".join(row))
print("Part 1:", solution.total_cost)
print("Part 2:", len(set([d[1].position for d in seen])))

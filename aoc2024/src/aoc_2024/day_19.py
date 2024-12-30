from functools import cache


with open("../../input/2024/19.txt") as f:
    data = f.read()
    [available, desired_patters] = data.split("\n\n")
    available = available.split(", ")
    desired_patters = desired_patters.split("\n")


@cache
def solve(pattern):
    if pattern == "":
        return 1
    ways = 0
    for towel in available:
        if pattern.startswith(towel):
            remaining = pattern[len(towel) :]
            ways += solve(remaining)

    return ways


ans = list(map(solve, desired_patters))
part1 = len([x for x in ans if x > 0])
print(part1)

part2 = sum(ans)
print(part2)

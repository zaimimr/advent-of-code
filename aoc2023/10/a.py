FILE = "input"


class Node:
    def __init__(self, pos, type):
        self.pos = pos
        self.distance = 0
        self.type = type
        self.checked = False
        self.contained = False

    def __str__(self) -> str:
        return self.type.__str__()

    def __repr__(self):
        return self.__str__()

    def handle_move(self, neightbour_pos):
        my_x, my_y = self.pos
        neightbour_x, neightbour_y = neightbour_pos
        match self.type:
            case "|":
                return neightbour_pos[0] == self.pos[0] and (
                    neightbour_pos[1] == self.pos[1] + 1
                    or neightbour_pos[1] == self.pos[1] - 1
                )
            case "-":
                return neightbour_pos[1] == self.pos[1] and (
                    neightbour_pos[0] == self.pos[0] + 1
                    or neightbour_pos[0] == self.pos[0] - 1
                )
            case "L":
                return (
                    neightbour_pos[0] == self.pos[0]
                    and neightbour_pos[1] == self.pos[1]-1
                ) or (
                    neightbour_pos[1] == self.pos[1]
                    and neightbour_pos[0] == self.pos[0]+1
                )
            case "J":
                return (
                    neightbour_pos[0] == self.pos[0]
                    and neightbour_pos[1] == self.pos[1]-1
                ) or (
                    neightbour_pos[1] == self.pos[1]
                    and neightbour_pos[0] == self.pos[0]-1
                )
            case "7":
                return (
                    neightbour_pos[0] == self.pos[0]
                    and neightbour_pos[1] == self.pos[1]+1
                ) or (
                    neightbour_pos[1] == self.pos[1]
                    and neightbour_pos[0] == self.pos[0]-1
                )
            case "F":
                return (
                    neightbour_pos[0] == self.pos[0]
                    and neightbour_pos[1] == self.pos[1]+1
                ) or (
                    neightbour_pos[1] == self.pos[1]
                    and neightbour_pos[0] == self.pos[0]+1
                )
            case ".":
                return False
            case "S":
                return True


data = [list(line) for line in open(FILE).read().splitlines()]

starting_point = None
for y in range(len(data)):
    for x in range(len(data[0])):
        if data[y][x] == "S":
            print("Found starting point")
            starting_point = (x, y)
            data[y][x] = Node((x, y), data[y][x])
            data[y][x].checked = True
        else:
            data[y][x] = Node((x, y), data[y][x])

stack = [starting_point]
main_loop = [starting_point]


def get_neighbours(pos):
    global stack
    x, y = pos
    for cord in [(x, y - 1), (x, y + 1), (x + 1, y), (x - 1, y)]:
        try:
            if data[cord[1]][cord[0]].checked:
                continue
            # print("Checking neighbour", cord, data[cord[1]][cord[0]].handle_move(pos), data[pos[1]][pos[0]].handle_move(cord))
            if data[cord[1]][cord[0]].handle_move(pos) and data[pos[1]][pos[0]].handle_move(cord):
                data[cord[1]][cord[0]].checked = True
                data[cord[1]][cord[0]].distance = data[pos[1]][pos[0]].distance + 1
                stack.append(cord)
                main_loop.append(cord)
        except IndexError:
            pass


while len(stack) > 0:
    pos = stack.pop(0)
    get_neighbours(pos)

for line in data:
    print(line)
if False:
    for line in data:
        for node in line:
            if node.type == "S":
                print("S", end="")
            else:
                print(node.distance, end="")
        print()

print("Max distance:", max([max([node.distance for node in line]) for line in data]))


for y in range(len(data)):
    for x in range(len(data[0])):
            if (x, y) in main_loop:
                continue
            left = 0
            right = 0
            top = 0
            bottom = 0
            i = x
            while i < len(line):
                if line[i].type in ("L", "J", "7", "F", "|", "-", "S") and (i, y) in main_loop:
                    right += 1
                i += 1
            i = x
            while i >= 0:
                if line[i].type in ("L", "J", "7", "F", "|", "-", "S") and (i, y) in main_loop:
                    left += 1
                i -= 1

            i = y
            while i < len(data):
                if data[i][x].type in ("L", "J", "7", "F", "|", "-", "S") and (x, i) in main_loop:
                    bottom += 1
                i += 1
            i = y
            while i >= 0:
                if data[i][x].type in ("L", "J", "7", "F", "|", "-", "S") and (x, i) in main_loop:
                    top += 1
                i -= 1
                

            
            if left != 0 and right != 0 and top != 0 and bottom != 0:
                if left == 1 or right == 1 or top == 1 or bottom == 1:
                    data[y][x].contained = True
                if left != right or top != bottom:
                    data[y][x].contained = True

#             inside = 0
# for i in range(len(data)):
#     if i in path:
#         continue
#     outside_right = outside_left = True
#     j = i
#     while j > 0:
#         if j in path and 1 in data[j]:
#             outside_right = not outside_right
#         if j in path and -1 in data[j]:
#             outside_left = not outside_left
#         j -= width

#     if not (outside_right or outside_left):
#         inside += 1


if True:
    for line in data:
        for node in line:
            print("I"if node.contained else "O", end="")
        print()

    print("Inside:", sum([sum([1 for node in line if node.contained]) for line in data]))
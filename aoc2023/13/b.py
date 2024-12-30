data = [pattern.split("\n") for pattern in open("input").read().split("\n\n")]


def check_row_reflection(pattern):

    for row in range(len(pattern)):
        if row == 0:
            continue
        smudge_fixed = False
        reflection = True
        for char in range(len(pattern[row])):
            if pattern[row][char] != pattern[row-1][char]:
                if not smudge_fixed:
                    smudge_fixed = True
                    continue
                
                reflection = False
                break
        if reflection:
            up = row
            down = row-1
            valid_reflection = True
            smudge_fixed = False
            while True:
                print(up, pattern[up], pattern[down], down)
                reflection = True
                for char in range(len(pattern[row])):
                    if pattern[up][char] != pattern[down][char]:
                        if not smudge_fixed:
                            smudge_fixed = True
                            continue
                        reflection = False
                        break
                if not reflection:
                    valid_reflection = False
                    break
                up += 1
                down -= 1
                if down < 0:
                    break
                if up >= len(pattern):
                    break
            if valid_reflection and smudge_fixed:
                return (True, row)
    return (False, 0)

def check_col_reflection(pattern):
    for col in range(len(pattern[0])):
        if col == 0:
            continue
        smudge_fixed = False
        reflection = True
        for row in range(len(pattern)):
            if pattern[row][col] != pattern[row][col-1]:
                if not smudge_fixed:
                    smudge_fixed = True
                    continue
                reflection = False
                break
        if reflection:
            left = col
            right = col-1
            valid_reflection = True
            smudge_fixed = False
            while True:
                reflection = True
                for row in range(len(pattern)):
                    if pattern[row][left] != pattern[row][right]:
                        if not smudge_fixed:
                            smudge_fixed = True
                            continue
                        reflection = False
                        break
                if not reflection:
                    valid_reflection = False
                    break
                left += 1
                right -= 1
                if right < 0:
                    break
                if left >= len(pattern[0]):
                    break
            if valid_reflection and smudge_fixed:
                return (True, col)
    return (False, 0)


s = 0

for pattern in data:
    print("--"*3)
    horizontal = check_row_reflection(pattern)
    vertical = check_col_reflection(pattern)
    print(horizontal, vertical)
    s += vertical[1] + horizontal[1]*100
print(s)
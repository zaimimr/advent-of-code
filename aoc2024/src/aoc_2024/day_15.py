grid, moves = open('../../input/2024/15.txt').read().split('\n\n')

def move(p, d):
    p += d
    if all([
        grid[p] != '[' or move(p+1, d) and move(p, d),
        grid[p] != ']' or move(p-1, d) and move(p, d),
        grid[p] != 'O' or move(p, d), grid[p] != '#']):
            grid[p], grid[p-d] = grid[p-d], grid[p]
            return True


for grid in grid, grid.translate(str.maketrans(
        {'#':'##', '.':'..', 'O':'[]', '@':'@.'})):

    grid = {i+j*1j:c for j,r in enumerate(grid.split())
                     for i,c in enumerate(r)}

    pos, = (p for p in grid if grid[p] == '@')

    for m in moves.replace('\n', ''):
        dir = {'<':-1, '>':+1, '^':-1j, 'v':+1j}[m]
        copy = grid.copy()

        if move(pos, dir): pos += dir
        else: grid = copy

    ans = sum(pos for pos in grid if grid[pos] in 'O[')
    print(int(ans.real + ans.imag*100))
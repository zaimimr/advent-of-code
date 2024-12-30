data = [[int(nr) for nr in line.split()] for line in open('input').read().splitlines()]

def func(seq):
	if sum(i != 0 for i in seq) == 0:
		return 0
	m = []
	for i in range(len(seq)-1):
		m.append(seq[i+1]-seq[i])
	return seq[-1] + func(m)

print("Part 1:", sum(func(seq) for seq in data))
print("Part 2:", sum(func(seq[::-1]) for seq in data))

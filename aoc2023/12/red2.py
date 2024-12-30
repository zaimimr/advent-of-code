from functools import cache

@cache # too slow without the cache - stpres function values
def numlegal(corrupted_spring_log: str, control: tuple) -> int:

    corrupted_spring_log = corrupted_spring_log.lstrip('.') # ignore leading dots

    # ['', ()] is legal
    if corrupted_spring_log == '':
        return int(control == ()) 

    # [s, ()] is legal so long as s has no '#' (we can convert '?' to '.')
    if control == ():
        return int(corrupted_spring_log.find('#') == -1) 

    # s starts with '#' so remove the first spring
    if corrupted_spring_log[0] == '#':
        if len(corrupted_spring_log) < control[0] or '.' in corrupted_spring_log[:control[0]]:
            return 0 # impossible - not enough space for the spring
        elif len(corrupted_spring_log) == control[0]:
            return int(len(control) == 1) #single spring, right size
        elif corrupted_spring_log[control[0]] == '#':
            return 0 # springs must be separated by '.' (or '?') 
        else:
            return numlegal(corrupted_spring_log[control[0]+1:],control[1:]) # one less spring

    return numlegal('#'+corrupted_spring_log[1:],control) + numlegal(corrupted_spring_log[1:],control)


springs = [c.strip().split() for c in open("input").readlines()]
ss = [[c[0],tuple(int(d) for d in c[1].split(','))] for c in springs]

print("Part 1 total:", sum(numlegal(s,c) for [s,c] in ss))


ss2 = [[(s[0]+'?')*4 + s[0],s[1]*5] for s in ss]
print("Part 2 total:", sum(numlegal(s,c) for [s,c] in ss2))

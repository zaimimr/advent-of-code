import re
import math
data = [re.split("\s+", i) for i in open("input").read().splitlines()]
ratio = {}
s = 1

new_time = ""
new_distance = ""

for time, current_distance in zip(data[0], data[1]):
    if not time.isdigit():
        continue
    new_time += time
    new_distance += current_distance
    time = int(time)
    current_distance = int(current_distance)
    c = 0
    for hold in range(int(math.sqrt(time)), time+1):
        distance = (time - hold) * hold
        if distance > (current_distance):
            c += 1

    s *= c        
print(s)

new_time = int(new_time)
new_distance = int(new_distance)
c = 0
for hold in range(int(math.sqrt(new_time)), new_time+1):
    distance = (new_time - hold) * hold
    if distance > (new_distance):
        c += 1
print(c)  


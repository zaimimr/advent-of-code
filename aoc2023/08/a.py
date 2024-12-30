import re
import threading
import math
data = open("input").read().splitlines()
steps = data.pop(0)

node_map = {}
for i in data[1:]:
    s = re.search(r"([A-Z, 0-9]{3}) = \(([A-Z, 0-9]{3}), ([A-Z, 0-9]{3})\)", i)
    node_map[s.group(1)] = {"L": s.group(2), "R": s.group(3)}

current_nodes = [k for k, v in node_map.items() if k[-1] == "A"]

s = []
lock = threading.Lock()

def find_last_z(node_map, steps,  node):
    global s
    step = 0
    current_node = node
    print("starting at", current_node)
    while current_node[-1] != "Z":
        i = step % len(steps)
        current_node = node_map[current_node][steps[i]]
        step += 1
    print("found z at", step, "for" , node)
    with lock:
        s.append(step)


threads = []

for start_node in current_nodes:
        thread = threading.Thread(target=find_last_z, args=(node_map,steps,start_node,))
        thread.start()
        threads.append(thread)

for thread in threads:
    thread.join()

print(s)
print(math.lcm(*s))
# create a thread for each node and run them in parallel


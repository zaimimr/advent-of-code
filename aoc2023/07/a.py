cards = ["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"]
types = ["high", "1pair", "2pairs", "3ofakind", "fullhouse", "4ofakind", "5ofakind"]

data = [{"hand": i.split(" ")[0], "bid": i.split(" ")[1]} for i in open("ex").read().splitlines()]

for idx, row in enumerate(data):
    count = {}
    for card in row["hand"]:
        count[card] = count.get(card, 0) + 1
    # B 
    is_task_B = True
    if is_task_B:
        if "J" in count and count["J"] != 5:
            j = count.pop("J")
            count[max(count, key=count.get)] += j
    count = list(count.values())
    count.sort(reverse=True)
    match count:
        case [5]: data[idx]["type"] = "5ofakind"
        case [4, 1]: data[idx]["type"] = "4ofakind"
        case [3, 2]: data[idx]["type"] = "fullhouse"
        case [3, 1, 1]: data[idx]["type"] = "3ofakind"
        case [2, 2, 1]: data[idx]["type"] = "2pairs"
        case [2, 1, 1, 1]: data[idx]["type"] = "1pair"
        case [1, 1, 1, 1, 1]: data[idx]["type"] = "high"

data.sort(key=lambda x: (types.index(x["type"])))

switched = False
run = True
while run:
    switched = False
    for idx, row in enumerate(data):
        if idx == 0:
            continue
        if data[idx - 1]["type"] == data[idx]["type"]:
            for i in range(5):
                if cards.index(data[idx - 1]["hand"][i]) > cards.index(data[idx]["hand"][i]):
                    data[idx - 1], data[idx] = data[idx], data[idx - 1]
                    switched = True
                    break
                if cards.index(data[idx - 1]["hand"][i]) < cards.index(data[idx]["hand"][i]):
                    break
    if not switched:
        run = False

s = 0
for idx, row in enumerate(data):
    s += int(row["bid"]) * (idx + 1) 
print(data)
print(s)

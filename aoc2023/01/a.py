import re
s = 0

z = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

digits = {
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9",
}

with open("a.txt", "r") as f:
    lines = f.readlines()
    for line in lines:
        line = line.strip()
        
        skrt = []

        for i in z:
            x = [m.start() for m in re.finditer(i, line)]
            for j in x:
                skrt.append((j, i))

        skrt.sort(key=lambda x: x[0])
        first = skrt[0][1]
        if not first.isdigit():
            first = digits[first]
        second = skrt[-1][1]
        if not second.isdigit():
            second = digits[second]
        num = int(f"{first}{second}")
        s += num
       
print(s)
        


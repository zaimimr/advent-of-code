import re


def part1(A=None):
    with open("../../input/2024/17.txt") as f:
        data = f.read()

    data = data.split("\n\n")
    registers = data[0]
    registers = [int(i) for i in re.findall(r"\d+", registers)]
    registers = {
        "A": registers[0] if A is None else A,
        "B": registers[1],
        "C": registers[2],
    }
    instructions = [int(i) for i in data[1].replace("Program: ", "").split(",")]

    def combo(opcode):
        match opcode:
            case 0:
                return 0
            case 1:
                return 1
            case 2:
                return 2
            case 3:
                return 3
            case 4:
                return registers["A"]
            case 5:
                return registers["B"]
            case 6:
                return registers["C"]
            case 7:
                raise ValueError("Op value cannot be 7")

    outputs = []
    pointer = 0
    while pointer < len(instructions):
        if pointer + 1 >= len(instructions):
            print("Error: Incomplete instruction at the end of the program")
            break
        opcode = instructions[pointer]
        operand = instructions[pointer + 1]
        match opcode:
            case 0:
                registers["A"] = registers["A"] // (2 ** combo(operand))
            case 1:
                registers["B"] = registers["B"] ^ operand
            case 2:
                registers["B"] = combo(operand) % 8
            case 3:
                if registers["A"] != 0:
                    pointer = operand
                    continue
            case 4:
                registers["B"] = registers["B"] ^ registers["C"]
            case 5:
                value = combo(operand) % 8
                outputs.append(value)
            case 6:
                registers["B"] = registers["A"] // (2 ** combo(operand))
            case 7:
                registers["C"] = registers["A"] // (2 ** combo(operand))

        pointer += 2

    if outputs:
        return outputs


def part2():
    with open("../../input/2024/17.txt") as f:
        data = f.read()
    data = data.split("\n\n")
    instructions = [int(i) for i in data[1].replace("Program: ", "").split(",")]
    
    outputs = []
    def reverse(digit, old_A=None):
        A = 8**digit
        for i in range(0, 8):
            if old_A is None:
                new_A = A * i
            else:
                new_A = old_A + (A * i)
            if new_A == 0:
                continue
            res = part1(new_A)
            if digit == 0:
                if res == instructions:
                    outputs.append(new_A)
            else:
                if res[digit] == instructions[digit]:
                    reverse(digit - 1, new_A)

    reverse(15)
    return min(outputs)


print("part1: ", ",".join(map(str, part1())))
print("part2: ", part2())

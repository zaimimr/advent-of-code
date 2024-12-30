import functools

def parse_input(s):
    a, b = s.split("\n\n")

    signals = {}
    for line in a.splitlines():
        a0, a1 = line.split(": ")
        signals[a0] = int(a1)

    gates = {}

    for line in b.splitlines():
        left, right = line.split(" -> ")
        parts = left.split()
        gates[right] = parts

    return signals, gates

def extract_num(prefix, d):
    bits = {}

    for wire, val in d.items():
        if wire.startswith(prefix):
            pos = int(wire[len(prefix) :])
            bits[pos] = val

    out_bits = [b for _, b in sorted(bits.items(), reverse=True)]
    out_bits = "".join(map(str, out_bits))

    return int(out_bits, base=2)

def run_wires(signals, gates):
    @functools.cache
    def e(wire):
        if wire in signals:
            return signals[wire]

        left, op, right = gates[wire]
        left = e(left)
        right = e(right)
        if op == "AND":
            return left & right
        if op == "OR":
            return left | right
        assert op == "XOR"
        return left ^ right

    try:
        bits = {}

        for wire in gates:
            if wire.startswith("z"):
                bits[wire] = e(wire)

        return extract_num("z", bits)
    except:
        return None

def part1(s):
    signals, gates = parse_input(s)

    answer = run_wires(signals, gates)

    print("The answer to part 1 is", answer)

def validate(signals, gates):
    x = extract_num("x", signals)
    y = extract_num("y", signals)

    target = x + y

    assert run_wires(signals, gates) == target
    print("Success! The swaps fixed the system, numbers added properly!")

def part2(puzzle_input):
    signals, gates = parse_input(puzzle_input)

    num_bits = max(int(wire[1:]) for wire in signals) + 1

    def find_error():
        op_to_wire = {}
        xy_xors = {}
        xy_ands = {}

        for wire, (left, op, right) in gates.items():
            op_to_wire[(left, op, right)] = wire
            if ((left.startswith("x") and right.startswith("y")) or
                (left.startswith("y") and right.startswith("x"))):
                
                assert left[1:] == right[1:], "Bit indices for x and y must match"
                bit_index = int(left[1:])

                if op == "XOR":
                    assert bit_index not in xy_xors, "We shouldn't assign the same bit twice"
                    xy_xors[bit_index] = wire
                elif op == "AND":
                    assert bit_index not in xy_ands, "We shouldn't assign the same bit twice"
                    xy_ands[bit_index] = wire
                else:
                    assert False, "Unexpected operation for x and y bits"

        assert len(xy_xors) == num_bits, "Number of XOR gates doesn't match bit count"
        assert len(xy_ands) == num_bits, "Number of AND gates doesn't match bit count"

        z_carry = {}

        for i in range(num_bits + 1):
            xid = "x" + str(i).zfill(2)
            yid = "y" + str(i).zfill(2)
            zid = "z" + str(i).zfill(2)

            if i == 0:
                if xy_xors[0] != zid:
                    op_target = (xid, "XOR", yid)
                    if op_target not in op_to_wire:
                        op_target = op_target[::-1]

                    return zid, op_to_wire[op_target]

                z_carry[0] = xy_ands[0]

            else:
                zout_target = (z_carry[i - 1], "XOR", xy_xors[i])

                if zout_target not in op_to_wire:
                    zout_target = zout_target[::-1]

                if zout_target not in op_to_wire:
                    current_left, current_op, current_right = gates[zid]
                    assert current_op == "XOR", "z_i should be produced by XOR"

                    if current_left == xy_xors[i]:
                        return current_right, z_carry[i - 1]
                    elif current_right == xy_xors[i]:
                        return current_left, z_carry[i - 1]
                    elif current_left == z_carry[i - 1]:
                        return current_right, xy_xors[i]
                    elif current_right == z_carry[i - 1]:
                        return current_left, xy_xors[i]
                    raise ValueError("Cannot automatically fix this scenario. Blame Zaim")

                zout = op_to_wire[zout_target]
                if zout != zid:
                    return zid, zout

                carry_and_target = (z_carry[i - 1], "AND", xy_xors[i])
                if carry_and_target not in op_to_wire:
                    carry_and_target = carry_and_target[::-1]
                carry_and = op_to_wire[carry_and_target]

                carry_target = (carry_and, "OR", xy_ands[i])
                if carry_target not in op_to_wire:
                    carry_target = carry_target[::-1]
                carry = op_to_wire[carry_target]

                z_carry[i] = carry

        return None

    swaps = []
    for _ in range(4):
        result = find_error()
        if not result:
            break
        first, second = result
        print(f"Swapping {first} with {second}...")
        gates[first], gates[second] = gates[second], gates[first]
        swaps.extend([first, second])

    validate(signals, gates)
    answer = ",".join(sorted(swaps))
    print("The answer to part 2 is", answer)



with open("../../input/2024/24.txt") as f:
    INPUT = f.read()
part1(INPUT)
part2(INPUT)

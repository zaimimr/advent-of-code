def valid_seed(seed_id, seeds):
    if seed_id == 0:
        return False
    

    for i in range(0, len(seeds), 2):
        if seed_id >= int(seeds[i]) and seed_id < int(seeds[i]) + int(seeds[i + 1]):
            print('SKRRTTT!!')
            return True
    return False

with open("input") as f:
    data = f.read().split("\n\n")
    seeds = [int(i) for i in data.pop(0).split(" ")[1:]]
    
    order = []
    for mapping in data:
        mapping_type, mapping = mapping.split(":")
        mapping = mapping.split("\n")
        mapping.pop(0)
        mapping_type = mapping_type.split(" ")[0].split("-")
        mapping_type.pop(1)
        source_type, target_type = mapping_type
        order.append((source_type, target_type, [[int(i) for i in m.split(" ")]for m in mapping]))
    location_id = 0
    seed_id = 13
    while not valid_seed(seed_id, seeds):
        location_id += 1
        source_value = location_id
        for step in reversed(order):
            target_type, source_type, mapping = step
            for map in mapping:
                destination, source, range_len = map
                if source_value >= destination and source_value <= destination + range_len:
                    source_value = source + (source_value - destination)
                    break
                source_value = source_value
        seed_id = source_value
        if location_id % 100000 == 0:
            print(location_id)
    print(location_id)

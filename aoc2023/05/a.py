import sys, os
class Seed:    
    def __init__(self, idx):
        self.seed = idx
    
    def __str__(self):
        return f"\nSeed {self.seed}:\n\tSoil: {self.soil}\n\tFertilizer: {self.fertilizer}\n\tWater: {self.water}\n\tLight: {self.light}\n\tTemperature: {self.temperature}\n\tHumidity: {self.humidity}\n\tLocation: {self.location}"

    def __repr__(self):
        return self.__str__()

# Disable
def blockPrint():
    sys.stdout = open(os.devnull, 'w')
def enablePrint():
    sys.stdout = sys.__stdout__

blockPrint()

with open("ex") as f:
    data = f.read().split("\n\n")
    
    seeds = [Seed(int(seed)) for seed in data.pop(0).split(" ")[1:]]
    
    for mapping in data:
        mapping_type, mapping = mapping.split(":")
        mapping = mapping.split("\n")
        mapping.pop(0)
        mapping_type = mapping_type.split(" ")[0].split("-")
        mapping_type.pop(1)
        source_type, target_type = mapping_type
        print("--"*10)
        print(mapping_type)
        for m in mapping:
            destination, source, range_len = m.split(" ")
            sourses = list(range(int(source), int(source) + int(range_len)))
            print(m)
            print(sourses)
            for seed in seeds:
                source_value = getattr(seed, source_type)

                if source_value >= int(source) and source_value < int(source) + int(range_len):
                    offset = source_value - int(source)
                    target_value = int(destination) + offset
                    print(f"For seed {seed.seed}, setting {target_type} to {target_value} because {source_type} has value {source_value} which is in range" )
                    setattr(seed, target_type, target_value)
                else:
                    try:
                        getattr(seed, target_type)
                    except:
                        print(f"For seed {seed.seed}, setting {target_type} to {source_value} which is the source_value" )
                        setattr(seed, target_type, int(source_value))
    enablePrint()
    low = float('inf')
    for seed in seeds:
        if seed.location < low:
            low = seed.location
    print(seeds)
    print(low)
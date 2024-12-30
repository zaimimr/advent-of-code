import itertools
import networkx as nx

G = nx.Graph()

with open("../../input/2024/23.txt") as f:
    for line in f:
        left, right = line.strip().split("-")
        G.add_edge(left, right)

all_cliques = nx.find_cliques(G)


def part1():
    trips = [
        combo
        for combo in itertools.combinations(G.nodes(), 3)
        if any(node.startswith("t") for node in combo)
        and G.subgraph(combo).number_of_edges() == 3
    ]
    print("part1", len(trips))


def part2():
    max_clique = max(all_cliques, key=len)
    password = ",".join(sorted(max_clique))
    print("part2", password)

part1()
part2()

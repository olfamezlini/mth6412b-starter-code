# Importation des objets

include("node.jl")
include("edge.jl")
include("graph.jl")

# Défintion d'un noeud, il faut que les paramètres data soient de même nature

node1 = Node("A", 3)
show(node1)

node2 = Node("B", 2)
show(node2)

# Défintion d'une arête, il faut que les paramètres data soient de même nature

edge = Edge("James", 10, node1, node2)
show(edge)

# Défintion d'un graphe, il faut que les paramètres data soient de même nature

G = Graph("Ick", [node1, node2], [edge])
show(G)

# Ajout d'une arête au graphe G

node3 = Node("C", 4)

node4 = Node("D", 5)

edge1 = Edge("Arthur", 20, node3, node4)

add_edge!(G, edge1)

show(G)

# Lecture de l'instance de TSP symétrique (bayg29.tsp)
# Le chemin du fichier de TSP symétrique doit être bien indiqué.

graph_nodes, graph_edges = read_stsp("instances/stsp/bayg29.tsp")
plot_graph(graph_nodes, graph_edges)


# Phase 1

# Importation du module Test

using Test

# Importation des objets

include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("composantes_connexe.jl")
include("kruskal.jl")
include("affichage_kruskal.jl")

# Défintion de noeuds, il faut que les paramètres data soient de même nature

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

println("N'oubliez pas d'indiquer l'emplacement du fichier .tsp correspondant.")

# Lecture de l'instance de TSP symétrique (ici, bayg29.tsp)
graph_nodes, graph_edges = read_stsp("instances/stsp/bayg29.tsp");

# Affichage de l'instance de TSP symétrique (ici, bayg29.tsp)
plot_graph(graph_nodes, graph_edges)

# Phase 2

# Application pour l'exemple du cours
affichage_arbre_minimal("instances/stsp/exemple_phase_2.tsp")

# Application pour un autre fichier .TSP
affichage_arbre_minimal("instances/stsp/bayg29.tsp")
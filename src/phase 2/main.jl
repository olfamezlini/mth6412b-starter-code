# Phase 1

# Importation du module Test et Dates
using Test
using Dates
using Revise

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

# Phase 2

println("N'oubliez pas d'indiquer l'emplacement du fichier .tsp correspondant.")

# Lecture de l'instance de TSP symétrique (ici, bayg29.tsp)
graph_nodes, graph_edges, edge_weights_dict = read_stsp("instances/stsp/swiss42.tsp")

# Mesurer le temps CPU pour l'exécution de Algorithme_Kruskal
result = @timed Algortihme_Kruskal(graph_edges, edge_weights_dict)

# Extraire le temps d'exécution et le résultat
arbre_minimal, poids_minimal = result[1][1], result[1][2]
temps_cpu = result[2]

# Afficher le résultat et le temps d'exécution
println("Arbre de recouvrement minimal : ", arbre_minimal)
println("Poids minimal : ", poids_minimal)
println("Temps CPU : ", temps_cpu, " secondes")

# Application pour l'exemple du cours
affichage_arbre_minimal("instances/stsp/swiss42.tsp")

# Application pour un autre fichier .TSP
#affichage_arbre_minimal_kruskal("instances/stsp/bayg29.tsp")

# Affichage de l'instance de TSP symétrique (ici, bayg29.tsp)
#plot_graph(graph_nodes, graph_edges)

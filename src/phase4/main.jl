using STSP

# phase 1

# Défintion de noeuds, il faut que les paramètres data soient de même nature
node1 = Node("A", 3)
#show(node1)

node2 = Node("B", 2)
#show(node2)

# Défintion d'une arête, il faut que les paramètres data soient de même nature
edge = Edge("James", 10, node1, node2)
#show(edge)

# Défintion d'un graphe, il faut que les paramètres data soient de même nature
G = Graph("Ick", [node1, node2], [edge])
show(G)

remove_node!(G, node1)
show(G)

remove_edge!(G, edge)
show(G)

graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/exemple_phase_4.tsp")
les_noeuds = [Node(string(i), i) for i in collect(keys(graph_nodes))];
# Vérifie que 'graph_edges' est un dictionnaire ou une structure valide.
les_aretes = [Edge(string(i) * "---" * string(j), edge_weights_dict[(i, j)], Node(string(i), 0), Node(string(j),0)) for i in 1:length(graph_edges) for j in graph_edges[i]];
graph = Graph("exemple_phase_4", les_noeuds, les_aretes);
one_tree, poids_minimal_one_tree = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 1, 2, 0.1);
println("poids minimal du one tree = ", poids_minimal_one_tree)
show(one_tree)

#one_tree_phase_4 = one_tree!(graph, arbre_minimal, Node("1", 0));
#show(one_tree_phase_4)

# Phase 2

#println("N'oubliez pas d'indiquer l'emplacement du fichier .tsp correspondant.")

# Lecture de l'instance de TSP symétrique (ici, bayg29.tsp)
graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/exemple_phase_2.tsp")

# Mesurer le temps CPU pour l'exécution de Algorithme_Kruskal
result = @timed Algortihme_Kruskal(graph_edges, edge_weights_dict)

# Extraire le temps d'exécution et le résultat
arbre_minimal, poids_minimal = result[1][1], result[1][2]
temps_cpu = result[2]
#show(result[1][1])

# Afficher le résultat et le temps d'exécution
#println("Arbre de recouvrement minimal : ", arbre_minimal)
#println("Poids minimal : ", poids_minimal)
#println("Temps CPU : ", temps_cpu, " secondes")

# Application de l'algorithme de kruskal
affichage_arbre_minimal_kruskal("../instances/stsp/exemple_phase_4.tsp")

# Phase 3

# Application de l'algorithme de prim
affichage_arbre_minimal_prim("../instances/stsp/exemple_phase_4.tsp", 2)

# Application de l'algorithme de prim
#affichage_arbre_minimal_prim("instances/stsp/brazil58.tsp", 1)


# Phase 4
# Application de l'algorithme RSL

#println("N'oubliez pas d'indiquer l'emplacement du fichier .tsp correspondant.")

# Lecture de l'instance de TSP symétrique (ici, exemple_phase_2.tsp)

#graph_nodes, graph_edges, edge_weights_dict = read_stsp("instances/stsp/exemple_phase_2.tsp")

#Algorithme_RSL(graph_edges, edge_weights_dict, 7, 1)

affichage_RSL("../instances/stsp/exemple_phase_4.tsp", 2, 2)
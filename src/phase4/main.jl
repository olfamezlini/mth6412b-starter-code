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

# Phase 2

#println("N'oubliez pas d'indiquer l'emplacement du fichier .tsp correspondant.")

# Lecture de l'instance de TSP symétrique (ici, bayg29.tsp)
graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/bayg29.tsp")

# Mesurer le temps CPU pour l'exécution de Algorithme_Kruskal
# result = @timed Algortihme_Kruskal(graph_edges, edge_weights_dict)

# Extraire le temps d'exécution et le résultat
arbre_minimal, poids_minimal = result[1][1], result[1][2]
temps_cpu = result[2]

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

# Tracer des résultats optimaux obtenus
affichage_RSL("../instances/stsp/exemple_phase_4.tsp", 1, 1)
affichage_RSL("../instances/stsp/bayg29.tsp", 17, 1)
affichage_RSL("../instances/stsp/bays29.tsp", 14, 1)
affichage_RSL("../instances/stsp/dantzig42.tsp",21, 2)
affichage_RSL("../instances/stsp/fri26.tsp",12, 1)
affichage_RSL("../instances/stsp/gr17.tsp", 7, 1)
affichage_RSL("../instances/stsp/gr21.tsp", 14, 1)
affichage_RSL("../instances/stsp/gr24.tsp", 24, 1)
affichage_RSL("../instances/stsp/gr48.tsp", 4, 2)
affichage_RSL("../instances/stsp/swiss42.tsp", 32, 1)

# Permet d'afficher la tournée avec la méthode RSL à partir d'un noeud de départ
affichage_HK("../instances/stsp/exemple_phase_4.tsp", 1, 1, 0.1, 2500, 100000)
affichage_HK("../instances/stsp/bayg29.tsp",16, 2, 1.2, 2500, 100000)
affichage_HK("../instances/stsp/bays29.tsp", 16, 2, 1.6, 2500, 100000)
affichage_HK("../instances/stsp/dantzig42.tsp", 30, 2, 0.6, 2500, 100000)
affichage_HK("../instances/stsp/fri26.tsp", 2, 1, 0.1, 2500, 100000)
affichage_HK("../instances/stsp/gr17.tsp",  4, 2, 0.2, 2500, 100000)
affichage_HK("../instances/stsp/gr21.tsp",  13, 1, 10.0, 2500, 100000)
affichage_HK("../instances/stsp/gr24.tsp",23, 1, 10.0, 2500, 100000)
affichage_HK("../instances/stsp/gr48.tsp", 26, 2, 1.4, 2500, 100000)
affichage_HK("../instances/stsp/swiss42.tsp", 39, 1, 0.1, 2500, 100000)

# Ces fonctions ont été utilisées pour trouver les paramètres optimaux
# Exemple avec le fichier gr17 (Cela prend environ une minute pour les deux méthodes)
a = comparaison_HK("gr17", 150)
b = comparaison_RSL("gr17")

# Comparaison des résultats entre les valeurs optimales, les résultats de RSL et de HK
# Ceci met environ 30 seconde à terminer
affichage_resultats_param_opt()
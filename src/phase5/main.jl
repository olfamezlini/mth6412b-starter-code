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
affichage_RSL("exemple_phase_4", 1, 1)
affichage_RSL("bayg29", 17, 1)
affichage_RSL("bays29", 14, 1)
affichage_RSL("dantzig42",21, 2)
affichage_RSL("fri26",12, 1)
affichage_RSL("gr17", 7, 1)
affichage_RSL("gr21", 14, 1)
affichage_RSL("gr24", 24, 1)
affichage_RSL("gr48", 4, 2)
affichage_RSL("swiss42", 32, 1)

# Permet d'afficher la tournée avec la méthode RSL à partir d'un noeud de départ
affichage_HK("exemple_phase_4", 1, 1, 0.1, 2500, 100000)
affichage_HK("bayg29",16, 2, 1.2, 2500, 100000)
affichage_HK("bays29", 16, 2, 1.6, 2500, 100000)
affichage_HK("dantzig42", 30, 2, 0.6, 2500, 100000)
affichage_HK("fri26", 2, 1, 0.1, 2500, 100000)
affichage_HK("gr17",  4, 2, 0.2, 2500, 100000)
affichage_HK("gr21",  13, 1, 10.0, 2500, 100000)
affichage_HK("gr24",23, 1, 10.0, 2500, 100000)
affichage_HK("gr48", 26, 2, 1.4, 2500, 100000)
affichage_HK("swiss42", 39, 1, 0.1, 2500, 100000)

# Ces fonctions ont été utilisées pour trouver les paramètres optimaux
# Exemple avec le fichier gr17 (Cela prend environ une minute pour les deux méthodes)
comparaison_HK("gr17", 150)
comparaison_RSL("gr17")

# Comparaison des résultats entre les valeurs optimales, les résultats de RSL et de HK
# Ceci met environ 30 seconde à terminer
affichage_resultats_param_opt()


# phase 5 


# Cas "blue-hour-paris"
instance = "blue-hour-paris"


construction_image(instance, "HK", "Kruskal", 1.0, 500, 100000)

# Cas "abstract-light-painting"
instance = "abstract-light-painting"


construction_image(instance, "HK", "Kruskal", 1.0, 500, 100000)

# Cas "alaska-railroad"
instance = "alaska-railroad"


construction_image(instance, "HK", "Kruskal", 1.0, 500, 100000)


# Cas "lower-kananaskis-lake" (optimal !)
instance = "lower-kananaskis-lake" 

construction_image(instance, "HK", "Kruskal", 1.0, 50, 100000)


# Cas "marlet2-radio-board"
instance = "marlet2-radio-board"


construction_image(instance, "HK", "Kruskal", 0.5, 25, 100000000)


# Cas "nikos-cat" (optimal !)
instance = "nikos-cat"


construction_image(instance, "HK", "Kruskal", 10.0, 10, 100000)


# Cas "pizza-food-wallpaper"
instance = "pizza-food-wallpaper"


construction_image(instance, "HK", "Kruskal", 1.0, 500, 100000)


# Cas "the-enchanted-garden"
instance = "the-enchanted-garden"


construction_image(instance, "HK", "Kruskal", 1.0, 500, 100000)


# Cas "tokyo-skytree-aerial" (optimal !)
instance = "tokyo-skytree-aerial"


construction_image(instance, "HK", "Kruskal", 10.0, 10, 100000)




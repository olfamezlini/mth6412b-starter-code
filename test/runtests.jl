using STSP, Test

function test_Algorithme_Prim()
  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/swiss42.tsp")
  # Exécution de l'algorithme
  arbre_minimal, poids_minimal = Algorithme_Prim(graph_nodes, graph_edges, edge_weights_dict, 5)
  # Affichage des résultats
  println("Méthode : Prim")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Arbre de recouvrement minimal: ")
  show(arbre_minimal)

  @test poids_minimal == 1079

  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/bayg29.tsp")
  # Exécution de l'algorithme
  arbre_minimal, poids_minimal = Algorithme_Prim(graph_nodes, graph_edges, edge_weights_dict, 5)
  # Affichage des résultats
  println("Méthode : Prim")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Arbre de recouvrement minimal: ")
  show(arbre_minimal)

  @test poids_minimal == 1319

  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/exemple_phase_2.tsp")
  # Exécution de l'algorithme
  arbre_minimal, poids_minimal = Algorithme_Prim(graph_nodes, graph_edges, edge_weights_dict, 5)
  # Affichage des résultats
  println("Méthode : Prim")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Arbre de recouvrement minimal: ")
  show(arbre_minimal)

  @test poids_minimal == 37
end

# Appeler la fonction de test
test_Algorithme_Prim()

function test_Algorithme_Kruskal()
  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/swiss42.tsp")
  # Exécution de l'algorithme
  arbre_minimal, poids_minimal = Algortihme_Kruskal(graph_edges, edge_weights_dict)
  # Affichage des résultats
  println("Méthode : Kruskal")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Arbre de recouvrement minimal: ")
  show(arbre_minimal)

  @test poids_minimal == 1079

  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/bayg29.tsp")
  # Exécution de l'algorithme
  arbre_minimal, poids_minimal = Algortihme_Kruskal(graph_edges, edge_weights_dict)
  # Affichage des résultats
  println("Méthode : Kruskal")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Arbre de recouvrement minimal: ")
  show(arbre_minimal)

  @test poids_minimal == 1319

  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/exemple_phase_2.tsp")
  # Exécution de l'algorithme
  arbre_minimal, poids_minimal = Algortihme_Kruskal(graph_edges, edge_weights_dict)
  # Affichage des résultats
  println("Méthode : Kruskal")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Arbre de recouvrement minimal: ")
  show(arbre_minimal)

  @test poids_minimal == 37
end

# Appeler la fonction de test
test_Algorithme_Kruskal()


function test_Algorithme_RSL()
  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/swiss42.tsp")
  # Exécution de l'algorithme
  ordre_tournée, poids_minimal = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 5, 2)
  # Affichage des résultats
  println("Méthode : RSL")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Ordre de la tournée RSL : ", ordre_tournée)

  @test poids_minimal < 2*get_instance_weight("swiss42")

  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/bayg29.tsp")
  # Exécution de l'algorithme
  ordre_tournée, poids_minimal = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 3, 1)
  # Affichage des résultats
  println("Méthode : RSL")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Ordre de la tournée RSL : ", ordre_tournée)

  @test poids_minimal < 2*get_instance_weight("bayg29")


end

# Appeler la fonction de test
test_Algorithme_RSL()

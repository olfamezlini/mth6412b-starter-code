using STSP, Test

function test_Algorithme_Prim()
  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/swiss42.tsp")
  edge_weights_dict = Dict(k => BigFloat(v) for (k, v) in edge_weights_dict)
  # Exécution de l'algorithme
  arbre_minimal, poids_minimal = Algorithme_Prim(graph_nodes, graph_edges, edge_weights_dict, 5)
  # Affichage des résultats
  println("Méthode : Prim")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Arbre de recouvrement minimal: ")
  show(arbre_minimal)

  @test poids_minimal == 1079

  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/bayg29.tsp")
  edge_weights_dict = Dict(k => BigFloat(v) for (k, v) in edge_weights_dict)
  # Exécution de l'algorithme
  arbre_minimal, poids_minimal = Algorithme_Prim(graph_nodes, graph_edges, edge_weights_dict, 5)
  # Affichage des résultats
  println("Méthode : Prim")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Arbre de recouvrement minimal: ")
  show(arbre_minimal)

  @test poids_minimal == 1319

  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/exemple_phase_2.tsp")
  edge_weights_dict = Dict(k => BigFloat(v) for (k, v) in edge_weights_dict)
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
  edge_weights_dict = Dict(k => BigFloat(v) for (k, v) in edge_weights_dict)
  # Exécution de l'algorithme
  arbre_minimal, poids_minimal = Algortihme_Kruskal(graph_edges, edge_weights_dict)
  # Affichage des résultats
  println("Méthode : Kruskal")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Arbre de recouvrement minimal: ")
  show(arbre_minimal)

  @test poids_minimal == 1079

  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/bayg29.tsp")
  edge_weights_dict = Dict(k => BigFloat(v) for (k, v) in edge_weights_dict)
  # Exécution de l'algorithme
  arbre_minimal, poids_minimal = Algortihme_Kruskal(graph_edges, edge_weights_dict)
  # Affichage des résultats
  println("Méthode : Kruskal")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Arbre de recouvrement minimal: ")
  show(arbre_minimal)

  @test poids_minimal == 1319

  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/exemple_phase_2.tsp")
  edge_weights_dict = Dict(k => BigFloat(v) for (k, v) in edge_weights_dict)
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
  println("Tournée RSL : ", ordre_tournée)

  @test poids_minimal < 2*get_instance_weight("swiss42")

  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/bayg29.tsp")
  # Exécution de l'algorithme
  ordre_tournée, poids_minimal = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 3, 1)
  # Affichage des résultats
  println("Méthode : RSL")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Tournée RSL : ", ordre_tournée)

  @test poids_minimal < 2*get_instance_weight("bayg29")
end

# Appeler la fonction de test
test_Algorithme_RSL()

function test_Algorithme_HK()
  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/exemple_phase_4.tsp")
  # Exécution de l'algorithme
  Tournee_HK, poids_minimal = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 1, 1, 0.1, 2500, 100000)
  # Affichage des résultats
  println("Méthode : HK")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Tournée HK : ", Tournee_HK)

  @test poids_minimal == 16.0

  
  graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/gr24.tsp")
  # Exécution de l'algorithme
  Tournee_HK, poids_minimal = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 23, 1, 10.0, 2500, 100000)
  # Affichage des résultats
  println("Méthode : HK")
  println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
  println("Tournée HK : ", Tournee_HK)

  @test poids_minimal == 1299.0
end

# Appeler la fonction de test
test_Algorithme_HK()
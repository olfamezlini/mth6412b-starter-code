# Importation du module Test et Dates
using Test
using Dates

# Importation des objets
include("read_stsp.jl")
include("prim.jl")

function test_Algorithme_Prim()
    graph_nodes, graph_edges, edge_weights_dict = read_stsp("instances/stsp/swiss42.tsp")
    # Exécution de l'algorithme
    arbre_minimal, poids_minimal = Algorithme_Prim(graph_edges, edge_weights_dict, 5)
    # Affichage des résultats
    println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
    println("Arbre de recouvrement minimal: ")
    show(arbre_minimal)
    
end

# Appeler la fonction de test
test_Algorithme_Prim()
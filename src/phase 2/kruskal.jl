
# Importation des objets

include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("composantes_connexe.jl")


"""
    (graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64})

...
# Arguments
- `graph_edges::Vector{Vector{Int64}}`: Vecteur représentant les arêtes dans le graphe considéré
- `edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}`: Dictionnaire stockant les poids des arêtes du graphe considéré
...

applique l'algorithme de Kruskal afin de renvoyer l'arbre de recouvrement minimal et son poids.
"""
function Algortihme_Kruskal(graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64})

    # Définition de l'arbre minimal
    arbre_minimal = Graph("Arbre_minimal_Kruskal", Node{Int64}[], Edge{Int64, Int64}[])
    # Test du type de l'arbre de recouvrement minimal
    @test typeof(arbre_minimal)==Graph{Int64, Int64}

    # Obtention des arêtes triées suivant les poids
    sorted_edges = sort(collect(edge_weights_dict), by=x -> x[2])
    # Test de la longueur de l'ensemble des arêtes triées avec la longueur de l'ensemble des arêtes
    @test length(sorted_edges) == length(edge_weights_dict)

    # Initialisation des composantes connexes (chaque nœud est une composante séparée au début)
    # On initialise le parent de chaque nœud étant lui-même
    Set_comp_connexes = CompConnexe("composantes_connexes", Dict{Int64, Int64}())
    initalization(Set_comp_connexes, graph_edges)

    # Test si les composantes connexes ont bien été initialisées
    @test length(Set_comp_connexes.ensemble_comp_connexes)==length(graph_edges)

    # Définition du poids minimal
    poids_minimal = 0

    for (arete, poids) in sorted_edges
        # Obtention du numéro du premier nœud
        node1 = arete[1]
        # Test du type de node1
        @test typeof(node1)==Int64

        # Obtention du numéro du deuxième nœud
        node2 = arete[2]
        # Test du type de node2
        @test typeof(node2)==Int64

        # Définition du nœud 1
        node_1 = Node(string(node1), 0)
        # Test du type de de node_1
        @test typeof(node_1) == Node{Int64}

        # Définition du nœud 2
        node_2 = Node(string(node2), 0)
        # Test du type de de node_2
        @test typeof(node_2) == Node{Int64}

        # Obtention du prent du noeud_1
        racine_1 = get_root(Set_comp_connexes, node1)
        # Test de la racine du noeud_1 obtenue
        @test typeof(racine_1)==Int64
        # Obtention du prent du noeud_2
        racine_2 = get_root(Set_comp_connexes, node2)
        # Test de la racine du noeud_2 obtenue
        @test typeof(racine_1)==Int64

        # S'ils n'ont pas le même parent
        if racine_1 != racine_2
            # Alors on veut réunir les deux parties connexes et donc on doit mettre à jour
            # les parents de l'une des deux parties connexes
            update_comp_connexes(Set_comp_connexes, racine_1, racine_2)

            # On définit l'arête correspondante si les deux parents sont différents
            arete = Edge(string(arete[1])*"---"*string(arete[2]), Int(poids), node_1, node_2)

            # On met à jour le poids de notre arbre de recouvrement minimal
            poids_minimal += Int(poids)

            # On ajoute l'arête dans l'arbre de recouvrement minimal
            add_edge!(arbre_minimal, arete)
            @test arbre_minimal.edges[end] == arete

            # On ajoute le nœud 1 dans l'arbre de recouvrement minimal
            add_node!(arbre_minimal, node_1)

            # On ajoute le nœud 2 dans l'arbre de recouvrement minimal
            add_node!(arbre_minimal, node_2)
        end
    end
    # On retourne l'arbre de recouvrement minimal et son poids correspondant
    return arbre_minimal, poids_minimal
end
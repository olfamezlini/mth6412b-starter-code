using Test

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
    @test typeof(arbre_minimal) == Graph{Int64, Int64}

    # Obtention des arêtes triées par poids
    sorted_edges = sort(collect(edge_weights_dict), by=x -> x[2])
    @test length(sorted_edges) == length(edge_weights_dict)

    # Initialisation des composantes connexes
    Set_comp_connexes = CompConnexe("composantes_connexes", Dict{Int64, Int64}(), Dict{Int64, Int64}())
    initalization(Set_comp_connexes, graph_edges)
    @test length(Set_comp_connexes.ensemble_comp_connexes) == length(graph_edges)

    # Définition du poids minimal
    poids_minimal = 0

    for (arete, poids) in sorted_edges
        node1, node2 = arete
        @test typeof(node1) == Int64 && typeof(node2) == Int64

        # Définition des nœuds
        node_1 = Node(string(node1), 0)
        node_2 = Node(string(node2), 0)
        @test typeof(node_1) == Node{Int64} && typeof(node_2) == Node{Int64}

        # Trouver les racines des nœuds avec compression de chemin
        racine_1 = get_root(Set_comp_connexes, node1)
        racine_2 = get_root(Set_comp_connexes, node2)
        @test typeof(racine_1) == Int64 && typeof(racine_2) == Int64

        # Si les nœuds n'ont pas la même racine, ils appartiennent à des composantes différentes
        if racine_1 != racine_2
            # Fusion des composantes en utilisant la règle de rang
            update_comp_connexes(Set_comp_connexes, racine_1, racine_2)

            # Définition de l'arête et mise à jour du poids
            edge = Edge(string(node1) * "---" * string(node2), Int(poids), node_1, node_2)
            poids_minimal += Int(poids)

            # Ajout de l'arête et des nœuds dans l'arbre de recouvrement minimal
            add_edge!(arbre_minimal, edge)
            @test arbre_minimal.edges[end] == edge

            # Ajout des nœuds si absents
            if !in(node_1, arbre_minimal.nodes)
                add_node!(arbre_minimal, node_1)
            end
            if !in(node_2, arbre_minimal.nodes)
                add_node!(arbre_minimal, node_2)
            end
        end
    end

    # Retourne l'arbre de recouvrement minimal et son poids total
    return arbre_minimal, poids_minimal
end

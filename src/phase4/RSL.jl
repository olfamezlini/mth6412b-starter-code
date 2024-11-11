# Importation du module Test et STSP
using STSP, Test
export parcours_preordre, Algorithme_RSL

"""
    parcours_preordre(tree::Dict{Int64, Vector{Int64}}, node::Int64, visited::Vector{Int64})

# Arguments
- `tree::Dict{Int64, Vector{Int64}}`: Un dictionnaire représentant l'arbre couvrant minimal. Chaque clé dans le dictionnaire est un nœud, et chaque valeur associée est un vecteur contenant les voisins connectés à ce nœud.
- `node::Int64::Dict{Tuple{Int64, Int64}, Float64}`:  Le nœud de départ pour le parcours en préordre. 
- `visited::Vector{Int64}`: Un vecteur contenant les nœuds déjà visités dans l'ordre où ils ont été parcourus. 

# Modifie
- `visited::Vector{Int64}`:  Ce vecteur est mis à jour à chaque appel récursif et contient l'ordre final des nœuds pour la tournée en préordre.

"""
function parcours_preordre(tree::Dict{Int64, Vector{Int64}}, node::Int64, visited::Vector{Int64})
    push!(visited, node)  # Ajouter le nœud actuel à l'ordre de visite
    for neighbor in tree[node]  # Parcourir les voisins
        if !(neighbor in visited)  # Vérifier si le voisin n'a pas encore été visité
            parcours_preordre(tree, neighbor, visited)
        end
    end
end


"""
    Algorithme_RSL(graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}, start_node::Int64, algo_Arbre_minimal::Int64)

Implémente l'algorithme de Rosenkrantz, Stearns et Lewis fournissant une tournée dont le poids est inférieur à 2 fois le poids d'une tournée optimale a prtir d'un arbre de recouvrement minimal.

# Arguments
- `graph_edges::Vector{Vector{Int64}}`: Vecteur représentant les arêtes dans le graphe.
- `edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}`: Dictionnaire stockant les poids des arêtes du graphe.
- `start_node::Int64`: Le nœud de départ.
- `algo_Arbre_minimal`:Un entier (1:Kruskal, 2:Prim) qui indique la méthode pour trouver l'arbre de recouvrement minimal d'un graphe.

# Retourne
- Une liste contenant la tournée minimal du graphe du départ
"""

function Algorithme_RSL(graph_nodes, graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}, start_node::Int64, algo_Arbre_minimal::Int64)
    if algo_Arbre_minimal ==1
        Arbre_minimal=Algortihme_Kruskal(graph_edges, edge_weights_dict)[1]
    elseif  algo_Arbre_minimal ==2
        Arbre_minimal=Algorithme_Prim(graph_nodes, graph_edges, edge_weights_dict, start_node)[1] 
    else
        error("Choix de l'algorithme non valide.")
    end
    # Construire le dictionnaire Arbre_minimal_dict à partir des arêtes du Arbre_minimal
    show(Arbre_minimal)
    # Initialiser le dictionnaire où chaque nœud aura une liste de ses voisins
    Arbre_minimal_dict = Dict{Int, Vector{Int}}()
    # Parcourir chaque arête
    for edge in edges(Arbre_minimal)
        # Extraire les deux nœuds connectés par l'arête
        node1 = parse(Int, edge.node_1.name)
        node2 = parse(Int, edge.node_2.name)

        # Ajouter node2 comme voisin de node1
        if !haskey(Arbre_minimal_dict, node1)
            Arbre_minimal_dict[node1] = []
        end
        push!(Arbre_minimal_dict[node1], node2)

        # Ajouter node1 comme voisin de node2
        if !haskey(Arbre_minimal_dict, node2)
            Arbre_minimal_dict[node2] = []
        end
        push!(Arbre_minimal_dict[node2], node1)
    end
    visited::Vector{Int64} = []
    parcours_preordre(Arbre_minimal_dict, start_node, visited)
    push!(visited, start_node)

    Poids_tournee = 0.0  # Initialiser le poids total de la tournée
    
    # Parcourir les nœuds de la tournée dans 'visited' et additionner les poids des arêtes
    for i in 1:(length(visited) - 1)
        node1 = visited[i]
        node2 = visited[i + 1]
        
        # Ajouter le poids de l'arête entre node1 et node2
        if (node1, node2) in keys(edge_weights_dict)
            Poids_tournee += edge_weights_dict[(node1, node2)]
        elseif (node2, node1) in keys(edge_weights_dict)
            Poids_tournee += edge_weights_dict[(node2, node1)]
        else
            error("Le graphe n'est pas complet !")
        end
    end
    Tournee_RSL = Graph("Tournee_RSL", Node{Int64}[], Edge{Int64, Float64}[])
    graph_edges = complete_graph_edges(graph_edges)
    
    # Obtention de tous les poids
    add_symmetry!(edge_weights_dict)

    # Creation du graph
    for i in 1:(length(visited) - 1)
        weight = edge_weights_dict[(visited[i], visited[i+1])]
        node1 = string(visited[i])
        node2 = string(visited[i+1])
        # Ajout du nœud1 dans l'arbre
        add_node!(Tournee_RSL, Node(node1, 0))
        # Ajout de l'arete dans l'arbre
        arete = Edge(node1*"--->"*node2, weight, Node(node1, 0), Node(node2, 0))
        add_edge!(Tournee_RSL, arete)
        # Ajout du nœud2 dans l'arbre
        add_node!(Tournee_RSL, Node(node2, 0))

    end

    println("Ordre de la tournée RSL : ", visited)
    return Tournee_RSL, Poids_tournee

end



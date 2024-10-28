
# Importation du module Test
using Test
# Importation des objets
include("node.jl")
include("edge.jl")
include("graph.jl")
include("priority_queue.jl")

"""
    Algorithme_Prim(graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}, start_node::Int64)

Implémente l'algorithme de Prim pour trouver l'arbre de recouvrement minimal d'un graphe.

# Arguments
- `graph_edges::Vector{Vector{Int64}}`: Vecteur représentant les arêtes dans le graphe.
- `edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}`: Dictionnaire stockant les poids des arêtes du graphe.
- `start_node::Int64`: Le nœud de départ de l'algorithme de Prim.

# Retourne
- Un tuple contenant l'arbre de recouvrement minimal et son poids total.
"""
function Algorithme_Prim(graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}, start_node::Int64)

    # Définition de l'arbre minimal
    arbre_minimal = Graph("Arbre_minimal_Prim", Node{Int64}[], Edge{Int64, Int64}[])
    poids_minimal = 0.0  # Poids total de l'arbre de recouvrement minimal

    # Dictionnaire de chaque nœud et de ses voisins
    NODES = Dict{Int, Vector{Tuple{Int, Int}}}() 

    # Parcourir chaque arête et construire le dictionnaire
    for edge in graph_edges
        node1, node2 = edge
        NODES[node1] = vcat(get(NODES, node1, Tuple{Int, Int}[]), [(node1, node2)])
        NODES[node2] = vcat(get(NODES, node2, Tuple{Int, Int}[]), [(node2, node1)])
    end

    # Ajout du nœud de départ dans l'arbre
    start_node = Node(string(start_node), 0)
    add_node!(arbre_minimal, start_node)

    # Initialisation de la file de priorité et ajout des voisins du nœud de départ
    pq = PriorityQueue{PriorityItem}()
    for neighbor in NODES[start_node]
        node1, node2 = neighbor
        weight = edge_weights_dict[(node1, node2)]
        push!(pq, PriorityItem(weight, node2))
    end

    # Set pour suivre les nœuds visités
    visited_nodes = Set([start_node])

    # Boucle principale de l'algorithme de Prim
    while !is_empty(pq)
        # Extraire le nœud ayant le poids le plus bas
        current_item = popfirst!(pq)
        current_node = current_item.node

        # Si le nœud est déjà visité, passer à l'itération suivante
        if current_node in visited_nodes
            continue
        end

        # Ajout de l'arête au graphe minimal
        weight = current_item.weight
        poids_minimal += weight
        node_1, node_2 = find_parent_and_neighbor(NODES, current_node, visited_nodes)
        arete = Edge("$(node_1)---$(node_2)", weight, node_1, node_2)
        add_edge!(arbre_minimal, arete)

        # Marquer le nœud actuel comme visité
        push!(visited_nodes, current_node)
        add_node!(arbre_minimal, Node(string(current_node), 0))

        # Ajouter les voisins non visités du nœud courant dans la file de priorité
        for neighbor in NODES[current_node]
            node1, node2 = neighbor
            if node2 ∉ visited_nodes
                push!(pq, PriorityItem(edge_weights_dict[(node1, node2)], node2))
            end
        end
    end

    return arbre_minimal, poids_minimal
end

"""
    find_parent_and_neighbor(NODES::Dict{Int, Vector{Tuple{Int, Int}}}, current_node::Int, visited_nodes::Set{Int})

Trouve le nœud parent déjà visité pour le `current_node`.
"""
function find_parent_and_neighbor(NODES, current_node, visited_nodes)
    for neighbor in NODES[current_node]
        node1, node2 = neighbor
        if node1 in visited_nodes
            return node1, node2
        end
    end
    throw(ArgumentError("No parent node found for node $current_node"))
end

# petit Exemple de test de l'algorithme TEMPORAIRE SERA EFFACÉE APRES
function test_Algorithme_Prim()
    # Exemples d'arêtes et de poids
    graph_edges = [[1, 2], [1, 3], [2, 4], [3, 4], [4, 5]]
    edge_weights_dict = Dict((1, 2) => 1.0, (1, 3) => 4.0, (2, 4) => 3.0, (3, 4) => 2.0, (4, 5) => 5.0)

    # Exécution de l'algorithme
    arbre_minimal, poids_minimal = Algorithme_Prim(graph_edges, edge_weights_dict, 1)

    # Affichage des résultats
    println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
    println("Arbre de recouvrement minimal: ")
    for edge in arbre_minimal.edges
        println(edge)
    end
end

# Appeler la fonction de test
test_Algorithme_Prim()

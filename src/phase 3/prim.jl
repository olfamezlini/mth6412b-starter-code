
# Importation du module Test
using Test
# Importation des objets
include("node.jl")
include("edge.jl")
include("graph.jl")
include("priority_queue.jl")
include("read_stsp.jl")

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
    arbre_minimal = Graph("Arbre_minimal_Prim", Node{Int64}[], Edge{Int64, Float64}[])

    # Test du type de l'arbre de recouvrement minimal
    @test typeof(arbre_minimal)==Graph{Int64, Float64}

    poids_minimal = 0.0  # Poids total de l'arbre de recouvrement minimal

    # Dictionnaire de chaque nœud et de ses voisins 
    NODES = Dict{Int, Vector{Tuple{Int, Int}}}() 

    # Parcourir chaque arête et construire le dictionnaire des voisins
    for i =1:length(graph_edges)
        for node in graph_edges[i]
            NODES[i] = vcat(get(NODES, i, Tuple{Int, Int}[]), [(i, node)])
        end
    end


    # Creation du noeud de depart a partir de start_node
    start_node_type = Node(string(start_node), 0)

    # Test du type de de start_node_type
    @test typeof(start_node_type) == Node{Int64}

    # Ajout du nœud de départ dans l'arbre
    add_node!(arbre_minimal, start_node_type)

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
        # Extraire le nœud ayant le poids le plus bas (Modification de popfirst! pour que la priorité sera pour ceux qui ont le poids minimal)
        current_item = popfirst!(pq)
        current_node = current_item.node
        current_node_type = Node(string(current_node), 0)

        # Test du type de de start_node_type
        @test typeof(current_node_type) == Node{Int64}

        # Si le nœud est déjà visité, passer à l'itération suivante
        if current_node in visited_nodes
            continue
        end
        
        # On met à jour le poids minimal de l'arret
        weight = current_item.weight

        # On met à jour le poids de notre arbre de recouvrement minimal
        poids_minimal += weight

        # Creation d'un noeud parent a chaque fois ce noeud connecteé a l'arbre 
        parent_node = Node("", 0)

        for (key, value) in edge_weights_dict
            # On cherche le neoud parent du noeud qui satisfait les condition du poids et des noeuds visités 
            if key[2]==parse(Int64,current_node_type.name) && edge_weights_dict[key]==weight && key[1] ∈ visited_nodes
                parent=key[1]
                parent_node.name=string(parent)
            end
        end

        # Ajout de l'arête et du noeud au graphe minimal
        arete = Edge(parent_node.name*"---"*current_node_type.name, weight, parent_node, current_node_type)
        add_edge!(arbre_minimal, arete)
        add_node!(arbre_minimal, current_node_type)

        #show(arbre_minimal)
        
        # Ajouter les voisins non visités du nœud courant dans la file de priorité
        for neighbor in NODES[current_node]
            node1, node2 = neighbor
            if node2 ∉ visited_nodes
                push!(pq, PriorityItem(edge_weights_dict[(node1, node2)], node2))
            end
        end

        # On met a jour le start_node par le dernier noeud ajouté a l'arbre 
        start_node_type = current_node_type

        # Marquer le nœud actuel comme visité
        push!(visited_nodes, parse(Int64, start_node_type.name))

    end
    # On retourne l'arbre de recouvrement minimal et son poids correspondant
    return arbre_minimal, poids_minimal
end


function test_Algorithme_Prim()
    graph_nodes, graph_edges, edge_weights_dict = read_stsp("instances/stsp/exemple_phase_2.tsp")
    # Exécution de l'algorithme
    arbre_minimal, poids_minimal = Algorithme_Prim(graph_edges, edge_weights_dict, 5)
    # Affichage des résultats
    println("Poids total de l'arbre de recouvrement minimal: ", poids_minimal)
    println("Arbre de recouvrement minimal: ")
    show(arbre_minimal)
    
end

# Appeler la fonction de test
test_Algorithme_Prim()

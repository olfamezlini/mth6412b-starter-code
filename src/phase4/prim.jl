
# Importation du module Test
using STSP, Test

export complete_graph_edges, add_symmetry!, Algorithme_Prim

"""
# Arguments
- `graph_edges::Vector{Vector{Int64}}`: Vecteur représentant les arêtes dans le graphe.


# Retourne
- graph_edges::Vector{Vector{Int64}} contenant l'ensemble des arêtes dans le graphe en prenant en compte les matrices adjacentes supérieures ou inférieures
"""
function complete_graph_edges(graph_edges)
    # Nombre total de nœuds
    num_nodes = length(graph_edges)

    # Initialise une nouvelle liste pour stocker le voisinage symétrique de chaque nœud
    symmetric_neighbors = [Set{Int}() for _ in 1:num_nodes]

    # Remplit la liste de voisins symétriques
    for i in 1:num_nodes
        for neighbor in graph_edges[i]
            # Ajouter le voisin pour le nœud `i`
            push!(symmetric_neighbors[i], neighbor)

            # Ajoute également `i` comme voisin pour `neighbor` (symétrie)
            if neighbor <= num_nodes  # Assure qu'on reste dans les limites
                push!(symmetric_neighbors[neighbor], i)
            end
        end
    end

    # Convertit chaque ensemble de voisins en liste triée pour une sortie lisible
    return [sort(collect(neighbors)) for neighbors in symmetric_neighbors]
end

"""
# Arguments
- `a::Dict{Tuple{Int64, Int64}, Float64}`: Dictionnaire représentant les poids


# Modifie
- a::Dict{Tuple{Int64, Int64}, Float64} contenant l'ensemble des poids dans le graphe en prenant en compte les matrices adjacentes supérieures ou inférieures
"""
function add_symmetry!(a::Dict{Tuple{Int64, Int64}, Float64})
    # Crée une liste des nouvelles paires inversées à ajouter pour éviter les modifications durant l'itération
    to_add = Dict{Tuple{Int64, Int64}, Float64}()
    
    # Parcourt chaque élément de `a` pour trouver les symétries manquantes
    for ((x, y), value) in a
        # Si l'inverse (y, x) n'existe pas, on le stocke dans `to_add`
        if !haskey(a, (y, x))
            to_add[(y, x)] = value
        end
    end
    
    # Ajoute les paires symétriques dans `a`
    merge!(a, to_add)
    return a
end

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
function Algorithme_Prim(graph_nodes::Dict{Int64, Vector{Float64}}, graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}, start_node::Int64)
    # Vérification si le nœud de départ est dans les nœuds du graphe
    
    # Définition de l'arbre minimal
    arbre_minimal = Graph("Arbre_minimal_Prim", Node{Int64}[], Edge{Int64, Float64}[])
    graph_edges = complete_graph_edges(graph_edges)
    # Obtention de tous les poids
    add_symmetry!(edge_weights_dict)

    # Obtention de tous les noeuds
    if length(graph_nodes) == 0
        graph_nodes_keys = Int64[]  # Initialiser comme un tableau vide d'Int64
        for (a, b) in keys(edge_weights_dict)
            if !(a in graph_nodes_keys)
                push!(graph_nodes_keys, a)
            end
            if !(b in graph_nodes_keys)
                push!(graph_nodes_keys, b)
            end
        end
    else
        graph_nodes_keys = collect(keys(graph_nodes))
    end    



    # Test du type de l'arbre de recouvrement minimal
    @test typeof(arbre_minimal)==Graph{Int64, Float64}

    poids_minimal = 0.0  # Poids total de l'arbre de recouvrement minimal

    # Dictionnaire de chaque nœud et de ses voisins 
    NODES = Dict{Int, Vector{Tuple{Int, Int}}}() 
    # Parcourir chaque arête et construire le dictionnaire des voisins
    for i in graph_nodes_keys
        for node in graph_edges[i]
            NODES[i] = get(NODES, i, Tuple{Int, Int}[])
            if !((i, node) in NODES[i] && (node, i) in NODES[i])
                NODES[i] = vcat(NODES[i], [(i, node)])
            end
            NODES[node] = get(NODES, node, Tuple{Int, Int}[])
            if !((i, node) in NODES[node] && (node, i) in NODES[node])
                NODES[node] = vcat(NODES[node], [(i, node)])
            end
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
        if haskey(edge_weights_dict, (node1, node2))
            weight = edge_weights_dict[(node1, node2)]
            push!(pq, PriorityItem(weight, node2))
        end
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
        if haskey(NODES, current_node)
            for neighbor in NODES[current_node]
                node1, node2 = neighbor
                if haskey(edge_weights_dict, (node1, node2))
                    if node2 ∉ visited_nodes
                        push!(pq, PriorityItem(edge_weights_dict[(node1, node2)], node2))
                    end
                end
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
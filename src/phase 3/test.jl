import Base.push!

# Définition d'une structure simple pour la File de Priorité
struct SimplePriorityQueue
    elements::Vector{Tuple{Int, Float64}}  # Vecteur pour contenir les éléments comme (nœud, clé)
end

# Fonction pour créer une nouvelle File de Priorité
function SimplePriorityQueue() 
    return SimplePriorityQueue([])
end

# Fonction pour ajouter un nouvel élément dans la File de Priorité
function push!(pq::SimplePriorityQueue, vertex::Int, key::Float64)
    push!(pq.elements, (vertex, key))
end

# Fonction pour retirer l'élément avec la clé minimale de la File de Priorité
function pop!(pq::SimplePriorityQueue)
    if isempty(pq.elements)  # Corrigé ici
        throw(ArgumentError("La File de Priorité est vide"))
    end
    min_index = argmin(pq.elements, by=x -> x[2])
    return popat!(pq.elements, min_index)  # Retirer et retourner l'élément avec la clé minimale
end

# Fonction pour vérifier si la File de Priorité est vide
function isempty(pq::SimplePriorityQueue)
    return isempty(pq.elements)  # Vérifie si la file de priorité est vide
end

# Fonction pour diminuer la clé d'un nœud dans la File de Priorité
function decrease_key!(pq::SimplePriorityQueue, vertex::Int, new_key::Float64)
    for i in 1:length(pq.elements)
        if pq.elements[i][1] == vertex
            pq.elements[i] = (vertex, new_key)
            return
        end
    end
end

# Fonction de l'algorithme de Prim
function Algorithme_Prim(graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}, start_node::Int64)
    edges = []  # Liste pour stocker les arêtes de l'arbre de recouvrement minimal
    total_weight = 0.0  # Poids total de l'arbre de recouvrement minimal
    unreach_set = Set(1:length(graph_edges))  # Ensemble de tous les nœuds (1-indexé)
    
    # Initialiser minEdge et key pour chaque nœud
    min_edge = Dict{Int64, Union{Tuple{Int64, Int64}, Nothing}}()  # Pour représenter l'arête minimale
    key = Dict{Int64, Float64}()  # Pour représenter le poids de l'arête minimale connectant chaque nœud à l'AR

    for (index, edge) in enumerate(graph_edges)
        u, v = edge
        min_edge[u] = nothing
        min_edge[v] = nothing
        key[u] = Inf
        key[v] = Inf
    end
    
    # Mettre la clé du nœud de départ à 0
    key[start_node] = 0.0
    
    # Créer une file de priorité et ajouter tous les nœuds
    pq = SimplePriorityQueue()
    for vertex in keys(key)
        push!(pq, vertex, key[vertex])
    end

    while !isempty(pq)
        # Extraire le nœud avec la clé minimale
        v_tuple = pop!(pq)
        v = v_tuple[1]  # Obtenir le nœud
        
        # Ajouter l'arête minimale à la liste d'arêtes si elle existe
        if min_edge[v] !== nothing
            push!(edges, min_edge[v])
            total_weight += edge_weights_dict[min_edge[v]]  # Ajouter le poids de l'arête au poids total
        end
        
        # Explorer les voisins de v
        for edge in graph_edges
            u, w = edge
            # Vérifier si l'arête actuelle est connectée au nœud extrait
            if u == v || w == v
                neighbor = (u == v) ? w : u
                edge_weight = edge_weights_dict[(min(u, w), max(u, w))]
                
                if neighbor in unreach_set && edge_weight < key[neighbor]
                    key[neighbor] = edge_weight
                    min_edge[neighbor] = (v, neighbor)  # Mettre à jour l'arête minimale pour le voisin
                    decrease_key!(pq, neighbor, key[neighbor])  # Diminuer la clé dans la file de priorité
                end
            end
        end
    end
    
    return (edges, total_weight)  # Retourner les arêtes de l'arbre de recouvrement minimal et son poids total
end

# Exemple de graphe avec arêtes et poids
graph_edges = [
    [1, 2],
    [1, 3],
    [2, 3],
    [2, 4],
    [3, 4]
]

edge_weights_dict = Dict(
    (1, 2) => 1.0,
    (1, 3) => 4.0,
    (2, 3) => 2.0,
    (2, 4) => 7.0,
    (3, 4) => 3.0
)

# Appel de l'algorithme de Prim à partir du nœud 1
mst_edges, total_weight = Algorithme_Prim(graph_edges, edge_weights_dict, 1)

# Affichage des arêtes de l'arbre de recouvrement minimal et du poids total
println("Arêtes de l'arbre de recouvrement minimal :")
for edge in mst_edges
    println("Edge de $(edge[1]) à $(edge[2]) avec poids $(edge_weights_dict[edge])")
end
println("Poids total de l'AR: $total_weight")

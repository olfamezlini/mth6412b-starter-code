# Phase 1

# Importation du module Test et Dates
using Test
using Dates

# Importation des objets
include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("composantes_connexe.jl")
include("kruskal.jl")
include("affichage_kruskal.jl")
include("prim.jl")
include("affichage_prim.jl")
include("priority_queue.jl")


# Défintion de noeuds, il faut que les paramètres data soient de même nature
node1 = Node("A", 3)
show(node1)

node2 = Node("B", 2)
show(node2)

# Défintion d'une arête, il faut que les paramètres data soient de même nature
edge = Edge("James", 10, node1, node2)
show(edge)

# Défintion d'un graphe, il faut que les paramètres data soient de même nature
G = Graph("Ick", [node1, node2], [edge])
show(G)

println("N'oubliez pas d'indiquer l'emplacement du fichier .tsp correspondant.")

# Lecture de l'instance de TSP symétrique (ici, bayg29.tsp)
graph_nodes, graph_edges = read_stsp("instances/stsp/bayg29.tsp");

# Affichage de l'instance de TSP symétrique (ici, bayg29.tsp)
plot_graph(graph_nodes, graph_edges)


# Phase 3

# Application pour l'exemple du cours
#affichage_arbre_minimal_prim("instances/stsp/exemple_phase_2.tsp")

# Application pour un autre fichier .TSP
#affichage_arbre_minimal_prim("instances/stsp/bayg29.tsp")


graph_nodes, graph_edges, edge_weights_dict = read_stsp("instances/stsp/exemple_phase_2.tsp")

# Déterminer le nœud de départ (premier nœud)
#start_node = first(keys(graph_nodes))
#print(start_node)


# Application de l'algorithme de Prim sur le graphe considéré
function Algorithme_Prim(graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}, start_node::Int64)
    edges = []  # List to hold edges of the minimum spanning tree
    total_weight = 0.0  # Total weight of the minimum spanning tree
    unreach_set = Set(1:length(graph_edges))  # Set of all vertices (1-indexed)
    
    # Initialize minEdge and key for each vertex
    min_edge = Dict{Int64, Union{Tuple{Int64, Int64}, Nothing}}()  # To represent the minimum edge
    key = Dict{Int64, Float64}()  # To represent the minimum weight key
    
    for (index, edge) in enumerate(graph_edges)
        u, v = edge
        min_edge[u] = nothing
        min_edge[v] = nothing
        key[u] = Inf
        key[v] = Inf
    end
    
    # Set the starting node key to 0
    key[start_node] = 0.0
    
    # Create a priority queue and add all vertices
    pq = PriorityQueue.PriorityQueue()
    for vertex in keys(key)
        PriorityQueue.push!(pq, vertex, key[vertex])
    end

    while !PriorityQueue.isempty(pq)
        # Extract the vertex with the minimum key
        v_tuple = PriorityQueue.pop!(pq)
        v = v_tuple[1]  # Get the vertex
        
        # Add the minimum edge to the edges list if it exists
        if min_edge[v] !== nothing
            push!(edges, min_edge[v])
            total_weight += edge_weights_dict[min_edge[v]]  # Add the weight of the edge to total weight
        end
        
        # Explore neighbors of v
        for edge in graph_edges
            u, w = edge
            # Check if the current edge connects to the extracted vertex
            if u == v || w == v
                neighbor = (u == v) ? w : u
                edge_weight = edge_weights_dict[(min(u, w), max(u, w))]
                
                if neighbor in unreach_set && edge_weight < key[neighbor]
                    key[neighbor] = edge_weight
                    min_edge[neighbor] = (v, neighbor)  # Update the minimum edge for the neighbor
                    PriorityQueue.decrease_key!(pq, neighbor, key[neighbor])  # Decrease the key in the priority queue
                end
            end
        end
    end
    
    return (edges, total_weight)  # Return the edges of the minimum spanning tree and its total weight
end

    


# Appel de l'algorithme de Prim
#arbre_minimal, total_weight = Algorithme_Prim(graph_edges, edge_weights_dict, start_node)
#println("Arbre de recouvrement minimal: ", arbre_minimal)
#println("Poids total de l'arbre: ", total_weight)

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
mst_edges, total_weight = PrimAlgorithm.Algorithme_Prim(graph_edges, edge_weights_dict, 1)

# Affichage des arêtes de l'arbre de recouvrement minimal et du poids total
println("Arêtes de l'arbre de recouvrement minimal :")
for edge in mst_edges
    println("Edge de $(edge[1]) à $(edge[2]) avec poids $(edge_weights_dict[edge])")
end
println("Poids total de l'AR: $total_weight")


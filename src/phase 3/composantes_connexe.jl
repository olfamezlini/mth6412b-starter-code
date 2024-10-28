import Base.show

using Revise

# Importation des objets
include("node.jl")
include("edge.jl")

"""Type abstrait dont d'autres types de composantes connexes dériveront."""
abstract type AbstractCompConnexe end

"""Type représentant les composantes connexes d'un graphe."""
# Type pour représenter les composantes connexes avec rang et compression de chemin
mutable struct CompConnexe <: AbstractCompConnexe
    name::String
    ensemble_comp_connexes::Dict{Int64, Int64}  # Représente les parents des nœuds
    rang::Dict{Int64, Int64}  # Représente le rang de chaque nœud
end

# Initialisation des composantes connexes. Chaque nœud est connexe à lui-même, avec un rang initial de 0.
function initalization(comp_connexes::CompConnexe, graph_edges::Vector{Vector{Int64}})
    for node = 1:length(graph_edges)
        comp_connexes.ensemble_comp_connexes[node] = node
        comp_connexes.rang[node] = 0
    end
end

# Trouve la racine d'un nœud avec compression de chemin
function get_root(comp_connexes::CompConnexe, node::Int64)
    # Compression de chemin
    if comp_connexes.ensemble_comp_connexes[node] != node
        comp_connexes.ensemble_comp_connexes[node] = get_root(comp_connexes, comp_connexes.ensemble_comp_connexes[node])
    end
    return comp_connexes.ensemble_comp_connexes[node]
end

# Fusion de deux composantes en utilisant la règle de rang
function update_comp_connexes(comp_connexes::CompConnexe, root_1::Int64, root_2::Int64)
    # Compare les rangs pour déterminer quelle racine devient le parent de l'autre
    if comp_connexes.rang[root_1] > comp_connexes.rang[root_2]
        comp_connexes.ensemble_comp_connexes[root_2] = root_1
    elseif comp_connexes.rang[root_1] < comp_connexes.rang[root_2]
        comp_connexes.ensemble_comp_connexes[root_1] = root_2
    else
        comp_connexes.ensemble_comp_connexes[root_2] = root_1
        comp_connexes.rang[root_1] += 1  # Incrémente le rang si les deux sont égaux
    end
end

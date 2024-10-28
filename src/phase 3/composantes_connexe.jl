import Base.show

# Importation des objets

include("node.jl")
include("edge.jl")

"""Type abstrait dont d'autres types de composantes connexes dériveront."""
abstract type AbstractCompConnexe end

"""Type représentant les composantes connexes d'un graphe.

Exemple:

        comp_connexes = CompConnexe("James", noeuds)

"""
mutable struct CompConnexe <: AbstractCompConnexe
    name::String
    ensemble_comp_connexes::Dict{Int64, Int64}  # Dictionnaire de chaque nœud et sa racine
    rangs::Dict{Int64, Int64}                   # Nouveau dictionnaire pour stocker le rang de chaque nœud
end

"""Initialisation des composantes connexes. Au départ, chaque nœud est connexe à lui-même et son rang est 0."""
function initialization(comp_connexes::CompConnexe, graph_edges::Vector{Vector{Int64}})
    for node in 1:length(graph_edges)
        comp_connexes.ensemble_comp_connexes[node] = node
        comp_connexes.rangs[node] = 0  # Le rang initial de chaque nœud est 0
    end
end

"""Renvoie la racine suivant un nœud présent dans une composante connexe avec compression de chemin."""
function get_root(comp_connexes::CompConnexe, node::Int64)
    if comp_connexes.ensemble_comp_connexes[node] != node
        # Compression de chemin : raccourci le chemin en pointant directement à la racine
        comp_connexes.ensemble_comp_connexes[node] = get_root(comp_connexes, comp_connexes.ensemble_comp_connexes[node])
    end
    return comp_connexes.ensemble_comp_connexes[node]
end

"""Fusionne deux composantes connexes via le rang."""
function update_comp_connexes(comp_connexes::CompConnexe, root_1::Int64, root_2::Int64)
    root1 = get_root(comp_connexes, root_1)
    root2 = get_root(comp_connexes, root_2)

    if root1 != root2
        # Union par le rang : attache l'arbre de plus petit rang sous l'arbre de plus grand rang
        if comp_connexes.rangs[root1] > comp_connexes.rangs[root2]
            comp_connexes.ensemble_comp_connexes[root2] = root1
        elseif comp_connexes.rangs[root1] < comp_connexes.rangs[root2]
            comp_connexes.ensemble_comp_connexes[root1] = root2
        else
            # Si les rangs sont égaux, on attache root2 sous root1 et on augmente le rang de root1
            comp_connexes.ensemble_comp_connexes[root2] = root1
            comp_connexes.rangs[root1] += 1
        end
    end
end

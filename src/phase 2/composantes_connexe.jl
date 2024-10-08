import Base.show


# Importation des objets

include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("kruskal.jl")
include("affichage_kruskal.jl")

"""Type abstrait dont d'autres types de composantes connexes dériveront."""
abstract type AbstractCompConnexe end

"""Type représentant les composantes connexes d'un graphe.

Exemple:

        comp_connexes = CompConnexe("James", noeuds)

"""
mutable struct CompConnexe <: AbstractCompConnexe
    name::String
    ensemble_comp_connexes::Dict{Int64, Int64}
end

"""Initialisation des composantes connexes. Au départ, chaque nœud est connexe à lui-même."""
initalization(comp_connexes::CompConnexe, graph_edges::Vector{Vector{Int64}}) = 
for node = 1:length(graph_edges)
    comp_connexes.ensemble_comp_connexes[node] = node
end


"""Renvoie la racine suivant un nœud présent dans une composante connexe"""
get_root(comp_connexes::CompConnexe, node::Int64) = comp_connexes.ensemble_comp_connexes[node]

"""Met à jour les racines lors de la fusion de deux composantes connexes"""
update_comp_connexes(comp_connexes::CompConnexe, root_1::Int64, root_2::Int64) = for (node, parent) in comp_connexes.ensemble_comp_connexes
    # Ici, nous mettons à jour tous les nœud dont le parent est celui du nœud 2,
    # car cela signifie qu'ils appartiennent à la même composante connexe.
    if parent == root_2
        comp_connexes.ensemble_comp_connexes[node] = root_1
    end
end
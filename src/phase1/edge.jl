import Base.show

# Importation des objets

include("node.jl")


"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{T,S} end

"""Type représentant les arêtes d'un graphe.

Exemple:

        edge = Edge("James", 10, node1, node2)

"""
mutable struct Edge{T,S} <: AbstractEdge{T,S}
    name::String
    data::S
    node_1::Node{T}
    node_2::Node{T}
end

# on présume que tous les arêtes dérivant d'AbstractEdge
# posséderont des champs 'name', 'data', 'node_1' et 'node_2'.

"""Renvoie le noeud 1."""
noeud_1(edge::AbstractEdge) = edge.node_1

"""Renvoie le noeud 2."""
noeud_2(edge::AbstractEdge) = edge.node_2

"""Renvoie le nom de l'arete."""
name(edge::AbstractEdge) = edge.name

"""Renvoie le poids de l'arete."""
data(edge::AbstractEdge) = edge.data

"""Affiche un arête."""
function show(edge::AbstractEdge)
  println("\nArete : ", name(edge), ", data : ", data(edge), ", noeud_1 : ", noeud_1(edge), ", noeud_2 : ", noeud_2(edge))
end

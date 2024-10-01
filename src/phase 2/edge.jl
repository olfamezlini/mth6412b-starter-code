import Base.show
include("node.jl")
"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{T} end

"""Type représentant les arêtes d'un graphe.

Exemple:
 
        edge = Edge("James", 10, node1, node2)

"""
mutable struct Edge{T} <: AbstractEdge{T}
    name::String
    data::T
    node_1::Node{T}
    node_2::Node{T}
end

# on présume que tous les arêtes dérivant d'AbstractEdge
# posséderont des champs 'name', 'data', 'node_1' et 'node_2'.

"""Renvoie le noeud 1."""
noeud_1(Edge::AbstractEdge) = Edge.node_1

"""Renvoie le noeud 2."""
noeud_2(Edge::AbstractEdge) = Edge.node_2

"""Renvoie le nom de l'arete."""
name(Edge::AbstractEdge) = Edge.name

"""Renvoie le poids de l'arete."""
data(Edge::AbstractEdge) = Edge.data

"""Affiche un arête."""
function show(Edge::AbstractEdge)
  println("\nArete : ", name(Edge), ", data : ", data(Edge), ", noeud_1 : ", noeud_1(Edge), ", noeud_2 : ", noeud_2(Edge))
end

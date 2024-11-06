using STSP

export Graph, add_node!, add_edge!, name, nodes, nb_nodes, edges, nb_edges, show

"""Type abstrait dont d'autres types de graphes dériveront."""
abstract type AbstractGraph{T, S} end

"""Type representant un graphe comme un ensemble de noeuds.

Exemple :

    node1 = Node("Joe", 3.14)
    node2 = Node("Steve", exp(1))
    node3 = Node("Jill", 4.12)
    G = Graph("Ick", [node1, node2, node3], [edge1, edge2, edge3])

Attention, tous les noeuds doivent avoir des données de même type.
"""
mutable struct Graph{T, S} <: AbstractGraph{T, S}
  name::String
  nodes::Vector{Node{T}}
  edges::Vector{Edge{T, S}}
end

"""Ajoute un noeud au graphe."""
function add_node!(graph::Graph{T,S}, node::Node{T}) where {T, S}
  boolean = true
  for node_in in graph.nodes
    if parse(Int64, node_in.name) == parse(Int64, node.name)
      boolean = false
    end
  end
  if boolean
    push!(graph.nodes, node)
    graph
  end
end

"""Ajoute un arete au graphe."""
function add_edge!(graph::Graph{T, S}, edge::Edge{T, S}) where {T, S}
  push!(graph.edges, edge)
  graph
end

# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs 'name', 'nodes' et 'edges.

"""Renvoie le nom du graphe."""
name(graph::AbstractGraph) = graph.name

"""Renvoie la liste des noeuds du graphe."""
nodes(graph::AbstractGraph) = graph.nodes

"""Renvoie le nombre de noeuds du graphe."""
nb_nodes(graph::AbstractGraph) = length(graph.nodes)

"""Renvoie la liste des aretes du graphe."""
edges(graph::AbstractGraph) = graph.edges

"""Renvoie le nombre de aretes du graphe."""
nb_edges(graph::AbstractGraph) = length(graph.edges)

"""Affiche un graphe"""
function show(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes and ", nb_edges(graph), " edges.")
  for node in nodes(graph)
    show(node)
  end
  for edge in edges(graph)
    show(edge)
  end
end

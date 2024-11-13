using STSP

export Graph, add_node!, remove_node!, add_edge!, remove_edge!, name, nodes, nb_nodes, edges, nb_edges, show, one_tree!, get_degree

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

"""Supprime un noeud du graphe"""
function remove_node!(graph::Graph{T,S}, node::Node{T}) where {T, S}
  graph.nodes = filter!(n -> n != node, nodes(graph))
end

"""Ajoute un arete au graphe."""
function add_edge!(graph::Graph{T, S}, edge::Edge{T, S}) where {T, S}
  push!(graph.edges, edge)
  graph
end

"""Supprime une arête du graphe"""
function remove_edge!(graph::Graph{T,S}, edge::Edge{T, S}) where {T, S}
  graph.edges = filter!(e -> e != edge, edges(graph))
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

"""Renvoie le degré d'un noeud"""
function get_degree(node::Node, graph::Graph)
  return sum([1 for edge in edges(graph) if name(node) == name(noeud_1(edge)) || name(node) == name(noeud_2(edge))])
end

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

"""Construction d'un 1-tree à partir d'un arbre de recouvrement"""
function one_tree!(graph::Graph, arbre_rec::Graph, start_node::Node)
  arete_min_1 = Edge("min_2", 2, Node("min_2_n", 0), Node("min_2_n_2", 0))
  weight_min_1 = Inf
  arete_min_2 = Edge("min_2", 2, Node("min_2_n", 0), Node("min_2_n_2", 0))
  weight_min_2 = Inf

  for edge in edges(graph)
    if noeud_1(edge) == start_node || noeud_2(edge) == start_node
        if edge in edges(arbre_rec)
          remove_edge!(arbre_rec, edge)
        end
        # Trouver les deux arêtes de poids minimum
        if data(edge) < weight_min_1 && !symetric(edge, arete_min_1)
          arete_min_1 = edge
          weight_min_1 = data(edge)
        elseif data(edge) < weight_min_2 && !symetric(edge, arete_min_2)
          arete_min_2 = edge
          weight_min_2 = data(edge)
        end
    end
  end

  # Ajouter les deux arêtes de poids minimum
  if arete_min_1 != nothing
      add_edge!(arbre_rec, arete_min_1)
  end
  if arete_min_2 != nothing
      add_edge!(arbre_rec, arete_min_2)
  end
end
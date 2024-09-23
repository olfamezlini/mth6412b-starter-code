### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ d60f02ce-0a83-4edb-9747-b3de9ba1ae2b
using Markdown

# ╔═╡ 5dfaa4bb-f544-43df-a390-a9e326784fed
using InteractiveUtils

# ╔═╡ 7ea81498-700d-4402-bea4-37b5203d088f
using Logging

# ╔═╡ 5b0505f0-ab35-4ebc-9458-1914a54c7bfa
md"""
### Mini rapport: Phase 1 du projet
"""

# ╔═╡ 56c69abe-5f9d-433d-87ee-ad4d14d7e4ac
md"""
##### 1. Récupérer le code de la phase 1 sur le site web du cours. Vous y trouverez une structure de données Node pour les noeuds d’un graphe et Graph pour le graphe proprement dit. On fournit également un jeu de fonctions qui lisent les fichiers au format de TSPLib. On se limite ici aux problèmes symétriques dont les poids sont donnés au format EXPLICIT . """

# ╔═╡ c49caeea-0bdd-4cd3-8e50-c739befecd98
md"""[https://github.com/olfamezlini/mth6412b-starter-code/tree/Phase-1/src/phase1](https://github.com/olfamezlini/mth6412b-starter-code/tree/Phase-1/src/phase1)"""


# ╔═╡ 2ca058c6-5f4b-47d1-9282-a8803eaf19c5
md""" On a créé un fork pour le projet fournit sur GitHub "MTH6412b-starter-code : Une fois que nous avons forké le projet, nous pouvons apporter toutes les modifications que nous souhaitons à cette copie. Cela vous permet de travailler sur les nouvelles fonctionnalités, de répondre aux questions et faire le travail demandé sans interférer avec le dépôt original."""

# ╔═╡ d16af9e4-e9fd-49df-97e4-b6af7193d63f
md"""
##### 2. Proposer un type Edge pour représenter les arêtes d’un graphe
"""

# ╔═╡ 11e677b5-6ac6-45f2-a5ad-4ad36fd2776c
md""" Nous avons définit la structure Edge de maniere semblale a celle de Node. La structure est décrite alors par un nom de type String, un poids d'un type général (DATA) et de deux noeuds de type Node. """

# ╔═╡ 789d0351-e2db-4250-8694-7003fbe1c17b
"""Type abstrait dont d'autres types d'arrêtes dériveront."""
abstract type AbstractEdge{T} end

# ╔═╡ 905d4a8a-9d15-45b3-8e3a-ffb33cd835b3
md"""
```julia
abstract type AbstractEdge{T} end
```
"""

# ╔═╡ d670b6ea-a115-4a5a-bf9e-0179b05fb447
md"""
```julia
  mutable struct Edge{T} <: AbstractEdge{T}
    name::String
    data::T
    node_1::Node{T}
    node_2::Node{T}
  end
```
"""

# ╔═╡ 5ffd582d-91f5-47d8-a184-d7b62cf76567
md"""
###### Exemple"""

# ╔═╡ 13d8a324-5850-4a1d-8206-bb4fe3c2a544
md""" Vous voyez ci-dissous un exemple de création d'une arête, cette arête est nommée James evec un poids de 10 et qui lie node1 et node2. """

# ╔═╡ c2519803-e129-405b-b1cc-21a2d3b647f2
md"""
```julia 
node1 = Node("A", 3)

node2 = Node("B", 2)

edge = Edge("James", 10, node1, node2)
```
"""

# ╔═╡ 7f5af2f7-3a44-4650-af58-c7d9f3600f33
md"""
###### Méthode d'affichage pour un type edge"""

# ╔═╡ b2dde163-2e25-4478-aeab-ba34df4e0f25
md""" Pour afficher une arête, on a créé la fonction show qui prend comme paramètre une arête et affiche les informations lui associer : """

# ╔═╡ 623cc0bd-c29f-47c4-aab6-fa948cbb331e
md"""
```julia
function show(Edge::AbstractEdge)
  println("\nArete : ", name(Edge), ", data : ", data(Edge), ", noeud_1 : ", noeud_1(Edge), ", noeud_2 : ", noeud_2(Edge))
end
```
"""

# ╔═╡ af9dca34-559f-42a1-8d0c-a202c9a80037
md"""
```julia 
show(node1)

show(node2)

show(edge)
```
"""

# ╔═╡ 073418fb-8b6b-4c30-baee-75651749b89c
md""" Le résultat de code ci-dessus est le suivant : """

# ╔═╡ e9330884-d1d0-4c0c-b181-014109997a0a
md"""
Node A, data: 3

Node B, data: 2

Arete : James, data : 10, noeud_1 : Node{Int64}("A", 3), noeud_2 : Node{Int64}("B", 2)
"""

# ╔═╡ 1d6336d0-411e-4431-b2b5-73e813adb904
md"""
##### 3. Étendre le type Graph afin qu’un graphe contienne ses arêtes. On se limite ici aux graphes non orientés. L’utilisateur doit pouvoir ajouter une arête à la fois à un graphe.

"""

# ╔═╡ 60e6dd05-1c53-441c-a92a-bfc5505f7db1
md""" Nous avons modifié le fichier Graph.jl, la fonction add_edge a été ajouté. """

# ╔═╡ cc928741-3463-4b58-b552-af710f92ae30
md"""
```julia
function add_edge!(graph::Graph{T}, edge::Edge{T}) where T
  push!(graph.edges, edge)
  graph
end
```
"""

# ╔═╡ 30d35ba2-4789-4f93-be23-15c034ae0146
md"""
##### 4.  Étendre la méthode d’affichage show d’un objet de type Graph afin que les arêtes du graphe soient également affichées

"""

# ╔═╡ 737fea6b-ee3f-42d6-964d-de2bcbe9c242
md""" Afin que la fonction show graph prenne en considération les arêtes et les affiche, la modification suivante était faite : 
"""

# ╔═╡ 61c286e5-cba5-43f0-ba50-6a4e219ba42a
md"""
```julia
function show(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes and ", nb_edges(graph), " edges.")
  for node in nodes(graph)
    show(node)
  end
  for edge in edges(graph)
    show(edge)
  end
end
```
"""

# ╔═╡ 281a9ab0-29c5-4491-8bb2-b1bed1b63eff
md"""
##### 5.  Étendre la fonction read_edges() de read_stsp.jl afin de lire les poids des arêtes (ils sont actuellement ignorés).

"""

# ╔═╡ bbdffecf-e537-4562-ba0e-b3e006965992
md"""
```julia
function read_edges(header::Dict{String}{String}, filename::String)

  edges = []
  # Définition d'une liste pour stocker les poids
  edge_weights = []
  edge_weight_format = header["EDGE_WEIGHT_FORMAT"]
  known_edge_weight_formats = ["FULL_MATRIX", "UPPER_ROW", "LOWER_ROW",
  "UPPER_DIAG_ROW", "LOWER_DIAG_ROW", "UPPER_COL", "LOWER_COL",
  "UPPER_DIAG_COL", "LOWER_DIAG_COL"]

  if !(edge_weight_format in known_edge_weight_formats)
    @warn "unknown edge weight format" edge_weight_format
    return edges, edge_weights
  end
```
"""

# ╔═╡ 621fe82a-ac2a-4b15-bdca-74925a115963
md"""
##### 6. Fournir un programme principal qui lit une instance de TSP symétrique dont les poids sont donnés au format EXPLICIT et construit un objet de type Graph correspondant.

"""

# ╔═╡ ecca1940-1745-4b48-8183-ce1f0f7b18c2
md""" Afin de répondre à cette question, nous avons créé un fichier nommé Main.jl, ou on a fait la Lecture de l'instance de TSP symétrique (bayg29.tsp) et on a construit l'objet de type graph correspondant. Vous pouvez voir ça sur la branche phase 1 en appuyant sur le lien ci-dessous. """

# ╔═╡ 60ae8928-896e-4ab1-81b3-5284ea72b686
md"""[https://github.com/olfamezlini/mth6412b-starter-code/blob/Phase-1/src/phase1/main.jl](https://github.com/olfamezlini/mth6412b-starter-code/blob/Phase-1/src/phase1/main.jl)"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
Logging = "56ddb016-857b-54e1-b83d-db4d58db5568"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.5"
manifest_format = "2.0"
project_hash = "348ed7e828d2091a44e211d4df367eb5f2d0eb19"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
"""

# ╔═╡ Cell order:
# ╠═d60f02ce-0a83-4edb-9747-b3de9ba1ae2b
# ╠═5dfaa4bb-f544-43df-a390-a9e326784fed
# ╠═7ea81498-700d-4402-bea4-37b5203d088f
# ╟─5b0505f0-ab35-4ebc-9458-1914a54c7bfa
# ╟─56c69abe-5f9d-433d-87ee-ad4d14d7e4ac
# ╟─c49caeea-0bdd-4cd3-8e50-c739befecd98
# ╟─2ca058c6-5f4b-47d1-9282-a8803eaf19c5
# ╟─d16af9e4-e9fd-49df-97e4-b6af7193d63f
# ╠═11e677b5-6ac6-45f2-a5ad-4ad36fd2776c
# ╟─789d0351-e2db-4250-8694-7003fbe1c17b
# ╟─905d4a8a-9d15-45b3-8e3a-ffb33cd835b3
# ╟─d670b6ea-a115-4a5a-bf9e-0179b05fb447
# ╟─5ffd582d-91f5-47d8-a184-d7b62cf76567
# ╟─13d8a324-5850-4a1d-8206-bb4fe3c2a544
# ╟─c2519803-e129-405b-b1cc-21a2d3b647f2
# ╟─7f5af2f7-3a44-4650-af58-c7d9f3600f33
# ╟─b2dde163-2e25-4478-aeab-ba34df4e0f25
# ╟─623cc0bd-c29f-47c4-aab6-fa948cbb331e
# ╟─af9dca34-559f-42a1-8d0c-a202c9a80037
# ╟─073418fb-8b6b-4c30-baee-75651749b89c
# ╟─e9330884-d1d0-4c0c-b181-014109997a0a
# ╟─1d6336d0-411e-4431-b2b5-73e813adb904
# ╟─60e6dd05-1c53-441c-a92a-bfc5505f7db1
# ╟─cc928741-3463-4b58-b552-af710f92ae30
# ╟─30d35ba2-4789-4f93-be23-15c034ae0146
# ╟─737fea6b-ee3f-42d6-964d-de2bcbe9c242
# ╟─61c286e5-cba5-43f0-ba50-6a4e219ba42a
# ╠═281a9ab0-29c5-4491-8bb2-b1bed1b63eff
# ╟─bbdffecf-e537-4562-ba0e-b3e006965992
# ╟─621fe82a-ac2a-4b15-bdca-74925a115963
# ╟─ecca1940-1745-4b48-8183-ce1f0f7b18c2
# ╟─60ae8928-896e-4ab1-81b3-5284ea72b686
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002


import Pluto
Pluto.run()
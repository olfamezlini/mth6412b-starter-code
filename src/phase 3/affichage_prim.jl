# Importation des objets
include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("prim.jl")  # Assurez-vous que vous avez une fonction d'algorithme de Prim ici.

"""
    (filename::String)

...
# Arguments
- `filename::String`: Chemin du fichier au format .tsp stockant le graphe considéré
...

Affiche l'application de l'algorithme de Prim sur le graphe considéré.
"""
function affichage_arbre_minimal_prim(filename::String)
    # Lecture du fichier filename
    graph_nodes, graph_edges, edge_weights_dict = read_stsp(filename)

    # Déterminer le nœud de départ (premier nœud)
    start_node = first(keys(graph_nodes))

    # Application de l'algorithme de Prim sur le graphe considéré
    arbre_minimal, poids_minimal = Algorithme_Prim(graph_edges, edge_weights_dict, start_node)

    # Récupération de l'ensemble des arêtes de l'arbre de recouvrement minimal
    arbre_edges = arbre_minimal.edges

    # Affichage du poids minimal trouvé grâce à l'algorithme de Prim
    println("Poids minimal trouvé : ", poids_minimal)

    # Affichage de l'arbre de recouvrement minimal
    show(arbre_minimal)

    # Définition d'une figure
    fig = plot(legend=false)

    # Vérifie si les nœuds ont des positions
    if !isempty(graph_nodes)
        # Affichage des arêtes du graphe en gris clair
        for k in 1:length(graph_edges)
            for j in graph_edges[k]
                if k <= length(graph_nodes) && j <= length(graph_nodes)
                    plot!([graph_nodes[k][1], graph_nodes[j][1]], [graph_nodes[k][2], graph_nodes[j][2]], linewidth=1.5, alpha=0.75, color=:lightgray)
                end
            end
        end

        # Affichage des arêtes de l'arbre de recouvrement minimal en rouge
        for arete in arbre_edges
            noeud_1_arete = parse(Int, name(noeud_1(arete)))
            noeud_2_arete = parse(Int, name(noeud_2(arete)))
            if noeud_1_arete <= length(graph_nodes) && noeud_2_arete <= length(graph_nodes)
                plot!([graph_nodes[noeud_1_arete][1], graph_nodes[noeud_2_arete][1]],
                      [graph_nodes[noeud_1_arete][2], graph_nodes[noeud_2_arete][2]],
                      linewidth=1.5, alpha=0.75, color=:red)
            end
        end

        # Affichage des points suivant les coordonnées indiquées dans le fichier filename
        xys = values(graph_nodes)
        x = [xy[1] for xy in xys]
        y = [xy[2] for xy in xys]
        scatter!(x, y)

    else
        # Affichage en cercle si les positions ne sont pas indiquées
        nodes_ajoutes = Dict{Int64, Tuple{Float64, Float64}}()
        rayon = 1000

        # Génération des coordonnées pour chaque noeud
        for i in 1:length(graph_edges)
            angle = 2 * π * (i - 1) / length(graph_edges)
            x = rayon * cos(angle)
            y = rayon * sin(angle)
            nodes_ajoutes[i] = (x, y)
        end

        # Affichage des arêtes du graphe en gris clair
        for k in 1:length(graph_edges)
            for j in graph_edges[k]
                if k in keys(nodes_ajoutes) && j in keys(nodes_ajoutes)
                    plot!([nodes_ajoutes[k][1], nodes_ajoutes[j][1]], 
                          [nodes_ajoutes[k][2], nodes_ajoutes[j][2]], 
                          linewidth=1.5, alpha=0.75, color=:lightgray)
                end
            end
        end

        # Affichage des arêtes de l'arbre de recouvrement minimal
        for arete in arbre_edges
            noeud_1_arete = parse(Int, name(noeud_1(arete)))
            noeud_2_arete = parse(Int, name(noeud_2(arete)))
            if noeud_1_arete in keys(nodes_ajoutes) && noeud_2_arete in keys(nodes_ajoutes)
                plot!([nodes_ajoutes[noeud_1_arete][1], nodes_ajoutes[noeud_2_arete][1]], 
                      [nodes_ajoutes[noeud_1_arete][2], nodes_ajoutes[noeud_2_arete][2]], 
                      linewidth=1.5, alpha=0.75, color=:red)
            end
        end

        # Collecte des coordonnées pour le scatter plot
        x = [xy[1] for xy in values(nodes_ajoutes)]
        y = [xy[2] for xy in values(nodes_ajoutes)]
        scatter!(x, y)
    end

    # Renvoie de la figure
    return fig
end

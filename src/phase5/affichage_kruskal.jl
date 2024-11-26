using STSP

export affichage_arbre_minimal_kruskal

"""
    (filename::String)

...
# Arguments
- `filename::String`: Chemin du fichier au format .tsp stockant le graphe considéré
...

Affiche l'application de l'algorithme de Kruskal en rouge sur le graphe considéré.
"""
function affichage_arbre_minimal_kruskal(filename::String)
    # Lecture du fichier filename
    graph_nodes, graph_edges, edge_weights_dict = read_stsp(filename)
    # Application de l'algorithme de Kruskal sur le graphe considéré
    arbre_minimal, poids_minimal = Algortihme_Kruskal(graph_edges, edge_weights_dict)
    # Récupération de l'ensemble des arête de l'arbre de recouvrement minimal
    arbre_edges = arbre_minimal.edges
    # Affichage du poids minimal trouvé grâce à l'algorithme de Kruskal
    println("poids minimal trouvé : ", poids_minimal)
    # Affichage de l'arbre de recouvrement minimal
    show(arbre_minimal)
    # Définition d'une figure
    fig = plot(legend=false)

    # On va alors afficher le graphe et par dessus, son arbre de recouvrement minimal trouvé grâce à 
    # l'algorithme de Kruskal.

    # S'il y a des positions indiquées pour les noeuds du graphe du fichier filename
    if length(graph_nodes) !=0

        # On affiche les arêtes du graphe en gris clair
        for k = 1:length(graph_edges) 
            for j in graph_edges[k]
                plot!([graph_nodes[k][1], graph_nodes[j][1]], [graph_nodes[k][2], graph_nodes[j][2]],
                linewidth=1.5, alpha=0.75, color=:lightgray)
            end
        end

        # On affiche les arêtes de l'arbre de recouvrement minimal en rouge
        for arete in arbre_edges
            noeud_1_arete = parse(Int,name(noeud_1(arete)))
            noeud_2_arete = parse(Int,name(noeud_2(arete)))
            plot!([graph_nodes[noeud_1_arete][1], graph_nodes[noeud_2_arete][1]], [graph_nodes[noeud_1_arete][2], graph_nodes[noeud_2_arete][2]],
            linewidth=1.5, alpha=0.75, color=:red)
        end

        # On affiche les points suivant les coordonnées indiquées dans le fichier filename
        xys = values(graph_nodes)
        x = [xy[1] for xy in xys]
        y = [xy[2] for xy in xys]
        scatter!(x, y)
        
        # On peut éventuellement sauvegarder la figure
        #savefig("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/mth6412b-starter-code/exemple_phase_2.png")
        
        # Renvoie de la figure
        fig

    # Sinon, cela veut dire que les positions des noeuds du graphe correspondant ne sont pas indiquées
    # alors, nous avons ici choisi la représentation de ces points suivant un cercle car 
    # ce dernier permet de visualiser l'ensemble des arêtes sans qu'une arête en cache une autre.
    else
        # Définition de l'ensemble des positions des noeuds
        nodes_ajoutes = Dict{Int64, Tuple{Float64, Float64}}()
        
        # Définition du rayon du cercle
        rayon = 1000

        # Génération des coordonnées aléatoires pour chaque noeud
        for i in 1:length(graph_edges)
            angle = 2*pi*(i-1)/length(graph_edges)
            x = rayon*cos(angle)
            y = rayon*sin(angle)
            nodes_ajoutes[i] = (x, y)
        end

        # On affiche les arêtes du graphe en gris clair
        for k = 1:length(graph_edges) 
            for j in graph_edges[k]
                plot!([nodes_ajoutes[k][1], nodes_ajoutes[j][1]], [nodes_ajoutes[k][2], nodes_ajoutes[j][2]],
                linewidth=1.5, alpha=0.75, color=:lightgray)
            end
        end

        # On affiche les points suivant les coordonnées calculées
        for arete in arbre_edges
            noeud_1_arete = parse(Int,name(noeud_1(arete)))
            noeud_2_arete = parse(Int,name(noeud_2(arete)))
            plot!([nodes_ajoutes[noeud_1_arete][1], nodes_ajoutes[noeud_2_arete][1]], [nodes_ajoutes[noeud_1_arete][2], nodes_ajoutes[noeud_2_arete][2]],
            linewidth=1.5, alpha=0.75, color=:red)
        end

        # Collecte des coordonnées pour le scatter plot
        x = [xy[1] for xy in values(nodes_ajoutes)] 
        y = [xy[2] for xy in values(nodes_ajoutes)]
        scatter!(x, y)

        # On peut éventuellement sauvegarder la figure
        #savefig("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/mth6412b-starter-code/bayg29.png")

        # Renvoie de la figure
        fig

    end
    # Affichage de l'arbre de recouvrement minimal suivant la méthode de la classe Graph
    
end
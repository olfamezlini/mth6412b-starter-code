
# Importation des objets

include("node.jl")
include("edge.jl")
include("graph.jl")
include("composantes_connexe.jl")

using Test

"""
    (graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64})

...
# Arguments
- `graph_edges::Vector{Vector{Int64}}`: Vecteur représentant les arêtes dans le graphe considéré
- `edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}`: Dictionnaire stockant les poids des arêtes du graphe considéré
...

applique l'algorithme de Kruskal afin de renvoyer l'arbre de recouvrement minimal et son poids.
"""
function Algortihme_Kruskal(graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64})

    # Définition de l'arbre minimal
    arbre_minimal = Graph("Arbre_minimal_Kruskal", Node{Int64}[], Edge{Int64, Int64}[])
    # Test du type de l'arbre de recouvrement minimal
    @test typeof(arbre_minimal)==Graph{Int64, Int64}

    # Obtention des arêtes triées suivant les poids
    sorted_edges = sort(collect(edge_weights_dict), by=x -> x[2])
    # Test de la longueur de l'ensemble des arêtes triées avec la longueur de l'ensemble des arêtes
    @test length(sorted_edges) == length(edge_weights_dict)
    
    # Initialisation des composantes connexes (chaque noeud est une composante séparée au début)
    # On initialise le parent de chaque noeud étant lui-même
    Set_comp_connexes = CompConnexe("composantes_connexes", Dict{Int64, Int64}())
    initalization(Set_comp_connexes, graph_edges)

    # Test si les composantes connexes ont bien été initialisées
    @test length(Set_comp_connexes.ensemble_comp_connexes)==length(graph_edges)

    # Définition du poids minimal
    poids_minimal = 0

    for (arete, poids) in sorted_edges
        # Obtention du numéro du premier noeud
        node1 = arete[1]
        # Test du type de node1
        @test typeof(node1)==Int64

        # Obtention du numéro du deuxième noeud
        node2 = arete[2]
        # Test du type de node2
        @test typeof(node2)==Int64

        # Définition du noeud 1
        node_1 = Node(string(node1), 0)
        # Test du type de de node_1
        @test typeof(node_1) == Node{Int64}

        # Définition du noeud 2
        node_2 = Node(string(node2), 0)
        # Test du type de de node_2
        @test typeof(node_2) == Node{Int64}

        # Obtention du prent du noeud_1
        racine_1 = get_root(Set_comp_connexes, node1)
        # Test de la racine du noeud_1 obtenue
        @test typeof(racine_1)==Int64
        # Obtention du prent du noeud_2
        racine_2 = get_root(Set_comp_connexes, node2)
        # Test de la racine du noeud_2 obtenue
        @test typeof(racine_1)==Int64

        # S'ils n'ont pas le même parent
        if racine_1 != racine_2
            # Alors on veut réunir les deux parties connexes et donc on doit mettre à jour
            # les parents de l'une des deux parties connexes
            update_comp_connexes(Set_comp_connexes, racine_1, racine_2)

            # On définit l'arête correspondante si les deux parents sont différents
            arete = Edge(string(arete[1])*"---"*string(arete[2]), Int(poids), node_1, node_2)

            # On met à jour le poids de notre arbre de recouvrement minimal
            poids_minimal += Int(poids)

            # On ajoute l'arête dans l'arbre de recouvrement minimal
            add_edge!(arbre_minimal, arete)
            @test arbre_minimal.edges[end] == arete

            # On ajoute le noeud 1 dans l'arbre de recouvrement minimal
            add_node!(arbre_minimal, node_1)

            # On ajoute le noeud 2 dans l'arbre de recouvrement minimal
            add_node!(arbre_minimal, node_2)
        end
    end
    # On retourne l'arbre de recouvrement minimal et son poids correspondant
    return arbre_minimal, poids_minimal
end


"""
    (filename::String)

...
# Arguments
- `filename::String`: Chemin du fichier au format .tsp stockant le graphe considéré
...

Affiche l'application de l'algorithme de Kruskal en rouge sur le graphe considéré.
"""
function affichage_arbre_minimal(filename::String)
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

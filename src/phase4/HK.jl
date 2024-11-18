using STSP
export Algorithme_HK, get_one_tree, decalage

"""
    decalage(removed_node_dict, removed_edge_vec, removed_weights_dict, racine)

Réalise un décalage d'indice pour trouver un sous arbre de recouvrement minimal

# Arguments
- `removed_node_dict`: Dictionnaire contenant le sous graphe sans le noeud racine.
- `removed_edge_vec`: Vecteur contenant les arêtes sans les arêtes avec le noeud racine.
- `removed_weights_dict`: Dictionnaire contenant les poids des arêtes du sous graphe.
- `racine::Int64`: Le nœud de départ.

# Retourne
- `removed_node_dict_copy` : Dictionnaire du sous graphe mais avec les indices décalées de 1.
- `removed_edge_vec_copy` : Vecteur du sous graphe mais avec les indices décalées de 1.
- `removed_weights_dict_copy` : Dictionanire du sous graphe mais avec les indices des arêtes décalées de 1.
"""
function decalage(removed_node_dict, removed_edge_vec, removed_weights_dict, racine)

    removed_edge_vec_copy = map(edge -> map(x -> x > racine ? x - 1 : x, edge), removed_edge_vec)

    removed_node_dict_copy = Dict{Int64, Vector{Float64}}()

    for key in collect(keys(removed_node_dict))
        if key > racine 
            removed_node_dict_copy[key-1] = removed_node_dict[key]
        else
            removed_node_dict_copy[key] = removed_node_dict[key]
        end
    end
    removed_node_dict = removed_node_dict_copy

    removed_weights_dict_copy = Dict{Tuple{Int64, Int64}, BigFloat}()

    for (a, b) in collect(keys(removed_weights_dict))
        if a > racine
            if b > racine
                removed_weights_dict_copy[(a-1, b-1)] = removed_weights_dict[(a, b)]
            else
                removed_weights_dict_copy[(a-1, b)] = removed_weights_dict[(a, b)]
            end
        else
            if b > racine
                removed_weights_dict_copy[(a, b-1)] = removed_weights_dict[(a, b)]
            else
                removed_weights_dict_copy[(a, b)] = removed_weights_dict[(a, b)]
            end
        end
    end

    removed_weights_dict = removed_weights_dict_copy

    return removed_node_dict_copy, removed_edge_vec_copy, removed_weights_dict_copy
end

"""
    increment_nodes(nodes::Vector{Node{T}}, racine::Int64)

Réalise le décalage pour le nom des noeuds en les augmentant par rapport à la racine afin de permettre l'utilisation des méthodes comme  l'algorithme de Kruskal ou de Prim.

# Arguments
- `nodes::Vector{Node{T}}`: Vecteur représentant les noeuds dans le graphe.
- `racine::Int64`: Noeud de départ.

# Retourne
- incremented_nodes : vecteur des noeuds mis à jour.
"""
function increment_nodes(nodes::Vector{Node{T}}, racine) where T
    incremented_nodes = Node{T}[]  # Liste pour stocker les nouveaux nœuds

    for node in nodes
        # Convertir le nom du nœud en entier pour comparer avec la racine
        node_value = parse(Int, node.name)

        if node_value >= racine
            # Incrémenter le nom du nœud s'il est supérieur à la racine
            new_name = string(node_value + 1)
            push!(incremented_nodes, Node{T}(new_name, node.data))
        else
            # Garder le nom du nœud inchangé si c'est la racine
            push!(incremented_nodes, node)
        end
    end

    return incremented_nodes
end

"""
    increment_edges(edges::Vector{Edge{T, S}}, racine::Int64)

Réalise le décalage en augmentant les indices par rapport à la racine afin de permettre l'utilisation des méthodes comme  l'algorithme de Kruskal ou de Prim.

# Arguments
- `edges::Vector{Edge{T, S}}`: Vecteur représentant les arêtes dans le graphe.
- `racine::Int64`: Noeud de départ.

# Retourne
- incremented_edges : vecteur modifié avec les bonnes valeurs des arêtes
- poids_minimal_sous_arbre : poids du sous arbre considéré
"""
function increment_edges(edges::Vector{Edge{T, S}}, racine) where {T, S}
    incremented_edges = Edge{T, S}[]  # Liste pour stocker les nouvelles arêtes
    poids_minimal_sous_arbre = 0
    for edge in edges
        # Incrémenter les noms des nœuds si leur valeur est supérieure à la racine
        new_node1 = if parse(Int, edge.node_1.name) >= racine
            Node{T}(string(parse(Int, edge.node_1.name) + 1), edge.node_1.data)
        else
            edge.node_1
        end

        new_node2 = if parse(Int, edge.node_2.name) >= racine
            Node{T}(string(parse(Int, edge.node_2.name) + 1), edge.node_2.data)
        else
            edge.node_2
        end

        # Créer le nouveau nom de l'arête basé sur les nouveaux noms des nœuds
        new_edge_name = new_node1.name * "---" * new_node2.name
        # Ajouter la nouvelle arête à la liste
        push!(incremented_edges, Edge{T, S}(new_edge_name, edge.data, new_node1, new_node2))
        poids_minimal_sous_arbre += edge.data
    end

    return incremented_edges, poids_minimal_sous_arbre
end

"""
    get_one_tree(graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}, racine::Int64, algo_Arbre_minimal::Int64)

Implémente la méthode pour trouver un 1-tree minimum avec la racine racine

# Arguments
- `graph_edges::Vector{Vector{Int64}}`: Vecteur représentant les arêtes dans le graphe.
- `edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}`: Dictionnaire stockant les poids des arêtes du graphe.
- `racine::Int64`: Le nœud de départ.
- `algo_Arbre_minimal::Int64`: Un entier (1:Kruskal, 2:Prim) qui indique la méthode pour trouver l'arbre de recouvrement minimal d'un graphe.

# Retourne
- Un 1-tree minimum avec la racine
"""
function get_one_tree(graph_nodes::Dict{Int64, Vector{Float64}}, graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, BigFloat}, racine::Int64, algo_Arbre_minimal::Int64)
    
    removed_node_dict = Dict(key => graph_nodes[key] for key in keys(graph_nodes) if key != racine)
    removed_edge_vec = [[i for i in graph_edges[k] if i != racine] for k in 1:length(graph_edges) if k != racine]
    removed_weights_dict = Dict((i, j) => edge_weights_dict[(i, j)] for i in 1:length(graph_edges) for j in graph_edges[i] if i != racine && j != racine)
    
    #removed_node_dict, removed_edge_vec, removed_weights_dict = decalage!(removed_node_dict, removed_edge_vec, removed_weights_dict, racine)
    removed_node_dict, removed_edge_vec, removed_weights_dict = decalage(removed_node_dict, removed_edge_vec, removed_weights_dict, racine)

    if algo_Arbre_minimal  ==1
        arbre_minimal, poids_minimal =Algortihme_Kruskal(removed_edge_vec, removed_weights_dict)
    elseif  algo_Arbre_minimal ==2
        arbre_minimal, poids_minimal=Algorithme_Prim(removed_node_dict, removed_edge_vec, removed_weights_dict, 1)
    else 
        error("Choix de l'algorithme non valide.")
    end

    incremented_nodes = increment_nodes(nodes(arbre_minimal), racine)
    push!(incremented_nodes, Node(string(racine), 0))
    incremented_edges, poids_minimal_sous_arbre = increment_edges(edges(arbre_minimal), racine)
    one_tree = Graph("one_tree", incremented_nodes, incremented_edges)
    arete_min_1 = nothing
    weight_min_1 = Inf
    arete_min_2 = nothing
    weight_min_2 = Inf
    for i in graph_edges[racine]
        if edge_weights_dict[(i, racine)] < weight_min_1
            weight_min_1 = edge_weights_dict[(i, racine)]
            arete_min_1 = Edge(string(i)*"---"*string(racine), weight_min_1, Node(string(i),0), Node(string(racine),0))
        elseif edge_weights_dict[(i, racine)] < weight_min_2
            weight_min_2 = edge_weights_dict[(i, racine)]
            arete_min_2 = Edge(string(i)*"---"*string(racine), edge_weights_dict[(i, racine)], Node(string(i),0), Node(string(racine),0))
        end
    end
    add_node!(one_tree, Node(string(racine),0))
    add_edge!(one_tree, arete_min_1)
    add_edge!(one_tree, arete_min_2)
    poids_minimal_one_tree = poids_minimal_sous_arbre + data(arete_min_1) + data(arete_min_2)

    return one_tree, poids_minimal_one_tree
end

"""
    Algorithme_HK(graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}, racine::Int64, algo_Arbre_minimal::Int64)

Implémente l'algorithme HK.

# Arguments
- `graph_edges::Vector{Vector{Int64}}`: Vecteur représentant les arêtes dans le graphe.
- `edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}`: Dictionnaire stockant les poids des arêtes du graphe.
- `racine::Int64`: Le nœud de départ.
- `algo_Arbre_minimal`: Un entier (1:Kruskal, 2:Prim) qui indique la méthode pour trouver l'arbre de recouvrement minimal d'un graphe.

# Renvoie
- Une liste contenant la tournée minimal du graphe du départ
"""
function Algorithme_HK(graph_nodes::Dict{Int64, Vector{Float64}}, graph_edges::Vector{Vector{Int64}}, edge_weights_dict::Dict{Tuple{Int64, Int64}, Float64}, racine::Int64, algo_Arbre_minimal::Int64, pas::Float64, compteur_max::Int64, limite::Int64)
    
    # Conversion du dictionnaire en nombre BigFloat pour mieux gérer les grands nombres
    edge_weights_dict = Dict(k => BigFloat(v) for (k, v) in edge_weights_dict)

    # Ajoute les symétries dans les poids du dictionnaire pour que la méthode soient fonctionnelle pour les instances données
    add_symmetry!(edge_weights_dict)

    # Copie du dictionnaire car ce dernier va être modifié avec la pénalisation
    edge_weights_dict_copy = copy(edge_weights_dict) ; 

    # Définition d'une période considérée
    period = floor(Int, length(graph_edges) / 2)

    # On complète graph_edges pour avoir l'ensemble des arêtes et que la méthode soit fonctionnelle pour l'ensemble des instances.
    graph_edges = complete_graph_edges(graph_edges)

    # Initialisation du 1-tree et des autres paramètres
    one_tree, poids_minimal_one_tree = get_one_tree(graph_nodes, graph_edges, edge_weights_dict, racine, algo_Arbre_minimal)
    k = 0
    pi_k = ones(BigFloat, nb_edges(one_tree));
    W = poids_minimal_one_tree - 2 * sum(pi_k)

    # Initialisation du 1-tree qui va varier
    one_tree_k = Graph("one_tree_k", Node{Int64}[], Edge{Int64, Int64}[])

    # Initialisation du gradient
    d_k = [get_degree(node, one_tree) for node in nodes(one_tree)]
    v_k_et = d_k-ones(Int, nb_nodes(one_tree))*2;
    one_tree_et = one_tree;
    poids_minimal_one_tree_et = poids_minimal_one_tree;
    
    # Initialisation du gradient à deux étapes précédentes
    v_k_1 = d_k-ones(Int, nb_nodes(one_tree))*2;

    # Initialisation des variables de gestion de la recherche
    compteur = 0;
    compteur_period = 0;

    while k < limite

        # On limite la recherche si la recherche a durée plus longtemps qu'une certaine période
        if compteur_period > period
            pas /= 2
            period = floor(Int, length(period) / 2)
        end

        # Mis à jour du 1-tree et de son poids pendant la boucle
        if k == 0
            one_tree_k, poids_minimal_one_tree_k = one_tree, poids_minimal_one_tree
        else
            one_tree_k, poids_minimal_one_tree_k = get_one_tree(graph_nodes, graph_edges, edge_weights_dict, racine, algo_Arbre_minimal)
        end

        # Calcul du poids décalé à cause des pénalités
        w_pi_k = poids_minimal_one_tree_k - 2 * sum(pi_k)
        
        # Obtention du max des poids décalé
        W = max(W,w_pi_k)

        # S'il le poids décalé a évolué à la dernière étape, alors, on double la période
        if compteur_period == period && w_pi_k == W
            period = 2*period
        end
        
        # Calcul du degré des noeuds du 1-tree considéré
        d_k = [get_degree(node, one_tree_k) for node in nodes(one_tree_k)]
        
        # Calcul du gradient
        v_k = d_k-ones(Int, nb_nodes(one_tree_k))*2;

        # Si la somme en valeur absolu est meilleur que celle déjà connue, alors on met à jour
        if sum(abs.(v_k)) < sum(abs.(v_k_et))
            one_tree_et = one_tree_k;
            poids_minimal_one_tree_et = poids_minimal_one_tree_k;
            v_k_et = v_k;
            compteur = 0;
        else
            compteur += 1
        end

        # Conditions d'arrêt
        if v_k == zeros(Int,nb_nodes(one_tree_k)) || compteur > compteur_max || pas == 0.0 || period == 0
            break
        end

        # Mis à jour des pénalités
        pi_k += pas*(0.7*v_k+0.3*v_k_1);

        # Retenu du gradient précédent
        v_k_1 = v_k

        i = 1;
        
        # On met à jour le dictionnaire des poids suivant la pénalité
        for edge in edges(one_tree_k)
            couple_1 = (parse(Int,name(noeud_1(edge))), parse(Int,name(noeud_2(edge))))
            couple_2 = (parse(Int,name(noeud_2(edge))), parse(Int,name(noeud_1(edge))))
            if haskey(edge_weights_dict, couple_1)
                edge_weights_dict[couple_1] += pi_k[i]
            end
            if haskey(edge_weights_dict, couple_2)
                edge_weights_dict[couple_2] += pi_k[i]
            end
            i += 1
        end

        k += 1 ;
        compteur_period += 1

    end

    # Ici on reprend la même méthode que dans l'algorithme RSL    
    Arbre_minimal_dict = Dict{Int, Vector{Int}}()
    # Parcourir chaque arête
    for edge in edges(one_tree_et)
        # Extraire les deux nœuds connectés par l'arête
        node1 = parse(Int, edge.node_1.name)
        node2 = parse(Int, edge.node_2.name)

        # Ajouter node2 comme voisin de node1
        if !haskey(Arbre_minimal_dict, node1)
            Arbre_minimal_dict[node1] = []
        end
        push!(Arbre_minimal_dict[node1], node2)

        # Ajouter node1 comme voisin de node2
        if !haskey(Arbre_minimal_dict, node2)
            Arbre_minimal_dict[node2] = []
        end
        push!(Arbre_minimal_dict[node2], node1)
    end

    visited::Vector{Int64} = []
    parcours_preordre(Arbre_minimal_dict, racine, visited)
    push!(visited, racine)

    Poids_tournee = 0.0  # Initialiser le poids total de la tournée

    # Parcourir les nœuds de la tournée dans 'visited' et additionner les poids des arêtes
    for i in 1:(length(visited) - 1)
        node1 = visited[i]
        node2 = visited[i + 1]
        # println("(node1, node2) = ", (node1, node2))
        # println("edge_weights_dict_copy = ", edge_weights_dict_copy[(node1, node2)])
        # Ajouter le poids de l'arête entre node1 et node2
        if (node1, node2) in keys(edge_weights_dict_copy)
            Poids_tournee += edge_weights_dict_copy[(node1, node2)]
        elseif (node2, node1) in keys(edge_weights_dict_copy)
            Poids_tournee += edge_weights_dict_copy[(node2, node1)]
        else
            error("Le graphe n'est pas complet !")
        end
    end
    Tournee_HK = Graph("Tournee_HK", Node{Int64}[], Edge{Int64, BigFloat}[])
    graph_edges = complete_graph_edges(graph_edges)

    # Creation du graphe
    for i in 1:(length(visited) - 1)
        weight = edge_weights_dict_copy[(visited[i], visited[i+1])]
        node1 = string(visited[i])
        node2 = string(visited[i+1])
        # Ajout du nœud1 dans l'arbre
        add_node!(Tournee_HK, Node(node1, 0))
        # Ajout de l'arete dans l'arbre
        arete = Edge(node1*"--->"*node2, weight, Node(node1, 0), Node(node2, 0))
        add_edge!(Tournee_HK, arete)
        # Ajout du nœud2 dans l'arbre
        add_node!(Tournee_HK, Node(node2, 0))

    end

    if algo_Arbre_minimal == 1
        println(" ")
        println("Avec la méthode Kruskal !")
    end
    
    if algo_Arbre_minimal == 2
        println(" ")
        println("Avec la méthode Prim !")
    end

    println("Ordre de la tournée HK : ", visited)

    return Tournee_HK, Poids_tournee
end
using STSP, Plots

export comparaison_HK, comparaison_all_HK, comparaison_RSL, comparaison_all_RSL

"""
    comparaison_HK(filename::String, valeur_comp::Int64)

# Arguments
- `filename::String`: Nom de l'instance considéré.
- `valeur_comp::Int64` : Valeur limite de la différence entre le poids trouvé et le point optimaml

# Permet d'appliquer la méhtode HK suivant le paramètre du noeud de départ, du pas et de la méthode utilisée pour réaliser une recherche d'optimale et renvoie:
- `best_i_prim`: Meilleur noeud trouvé avec la méthode de Prim
- `best_poids_prim` : Meilleur poids trouvé avec la méthode de Prim
- `best_pas_prim` : Meilleur pas trouvé avec la méthode de Prim
- `best_i_kruskal` : Meilleur noeud trouvé avec la méthode de Kruskal
- `best_poids_kruskal`: Meilleur poids trouvé avec la méthode de Kruskal
- `best_pas_kruskal` : Meilleur pas trouvé avec la méthode de Kruskal
"""
function comparaison_HK(filename::String, valeur_comp::Int64)
    
    graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/"*filename*".tsp")

    start_node_vec = [i for i in 1:length(graph_edges)]

    pas_vec = [0.1:0.1:1; 1:0.2:2; 3:2:8; 9; 10:10:50]

    dif_val_tournee_prim = Matrix{Float64}(undef, length(start_node_vec), length(pas_vec))
    stsp_weight = get_instance_weight(filename)

    best_i_prim = nothing
    best_pas_prim = nothing
    best_poids_prim = Inf

    for (i, start_node) in enumerate(start_node_vec)
        for (j, pas) in enumerate(pas_vec)
            _, poids_minimal = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, start_node, 1, pas, 2500, 100000)
            dif_val_tournee_prim[i, j] = poids_minimal - stsp_weight
            if poids_minimal < best_poids_prim
                best_i_prim = i 
                best_pas_prim = pas
                best_poids_prim = poids_minimal
            end
        end
    end

    heatmap(
        pas_vec,                    
        start_node_vec,            
        dif_val_tournee_prim,   
        color=cgrad([:green,:yellow]), 
        clim = (0,valeur_comp),
        xlabel="pas", ylabel="Noeud de départ",
        title="Différences de poids (HK - STSP) avec Prim",
        xscale=:log10 
    )

    # Enregistrement de la figure
    #savefig("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/"*filename*"_prim.png")

    println("best_i = ", best_i_prim)
    println("best_pas = ", best_pas_prim)
    println("best_poids = ", best_poids_prim)

    dif_val_tournee_kruskal = Matrix{Float64}(undef, length(start_node_vec), length(pas_vec))
    stsp_weight = get_instance_weight(filename)

    best_i_kruskal = nothing
    best_pas_kruskal = nothing
    best_poids_kruskal = Inf

    for (i, start_node) in enumerate(start_node_vec)
        for (j, pas) in enumerate(pas_vec)
            _, poids_minimal = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, start_node, 2, pas, 2500, 100000)
            dif_val_tournee_kruskal[i, j] = poids_minimal - stsp_weight
            if poids_minimal < best_poids_kruskal
                best_i_kruskal = i 
                best_pas_kruskal = pas
                best_poids_kruskal = poids_minimal
            end
        end
    end

    heatmap(
        pas_vec,                    
        start_node_vec,            
        dif_val_tournee_kruskal,   
        color=cgrad([:green,:yellow]), 
        clim = (0,valeur_comp),
        xlabel="pas", ylabel="Noeud de départ",
        title="Différences de poids (HK - STSP) avec Kruskal",
        xscale=:log10 
    )

    # Enregistrement de la figure
    #savefig("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/"*filename*"_kruskal.png")

    println("best_i = ", best_i_kruskal)
    println("best_pas = ", best_pas_kruskal)
    println("best_poids = ", best_poids_kruskal)

    return best_i_prim, best_pas_prim, best_poids_prim, best_i_kruskal, best_pas_kruskal, best_poids_kruskal

end

"""
    comparaison_all_HK()

# Permet d'enregistrer les meilleures paramètres trouvés lors de la recherche avec la méthode HK.
"""
function comparaison_all_HK()
    best_parameters  = Dict()
    resultats = comparaison_HK("exemple_phase_4", 1)
    best_parameters["exemple_phase_4"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison_HK("gr17", 150)
    best_parameters["gr17"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison_HK("gr21", 150)
    best_parameters["gr21"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison_HK("gr24", 150)
    best_parameters["gr24"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, v1alue) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison_HK("fri26", 150)
    best_parameters["fri26"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison_HK("dantzig42", 300)
    best_parameters["dantzig42"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison_HK("swiss42", 300)
    best_parameters["swiss42"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison_HK("gr48", 2000)
    best_parameters["gr48"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison_HK("hk48", 2700)
    best_parameters["hk48"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison_HK("bayg29", 300)
    best_parameters["bayg29"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison_HK("bays29", 300)
    best_parameters["bays29"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
end

"""
    comparaison_RSL(filename::String)

# Arguments
- `filename::String`: Nom de l'instance considéré.

# Permet d'appliquer la méhtode RSL suivant le paramètre du noeud de départ et de la méthode utilisée pour réaliser une recherche d'optimale et renvoie:
- `best_i_prim`: Meilleur noeud trouvé avec la méthode de Prim
- `best_poids_prim` : Meilleur poids trouvé avec la méthode de Prim
- `best_i_kruskal` : Meilleur noeud trouvé avec la méthode de Kruskal
- `best_poids_kruskal`: Meilleur poids trouvé avec la méthode de Kruskal
"""
function comparaison_RSL(filename::String)
    
    graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/"*filename*".tsp")

    # Initialisation
    start_node_vec = collect(1:length(graph_edges))  # Liste des nœuds de départ
    dif_val_tournee_prim = Vector{Float64}(undef, length(start_node_vec))  # Vecteur pour stocker les différences
    stsp_weight = get_instance_weight(filename)  # Poids STSP de référence

    best_i_prim = nothing
    best_poids_prim = Inf

    # Calcul des poids minimaux pour chaque nœud de départ
    for (i, start_node) in enumerate(start_node_vec)
        _, poids_minimal = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, start_node, 2)
        println("poids_minimal = ", poids_minimal)

        # Calcul de la différence
        dif_val_tournee_prim[i] = poids_minimal - stsp_weight

        # Mise à jour du meilleur poids
        if poids_minimal < best_poids_prim
            best_i_prim = i
            best_poids_prim = poids_minimal
        end
    end

    # Création de l'histogramme
    bar(
        [i for i in 1:length(dif_val_tournee_prim)],                   # Indices des nœuds en abscisse
        dif_val_tournee_prim,             # Valeurs des différences en ordonnée
        xlabel="Nœud de départ",         # Nom de l'axe X
        ylabel="Différence (RSL - STSP)", # Nom de l'axe Y
        title="Différences de poids (RSL - STSP) avec Prim", # Titre
        legend=false,
        color=:blue                       # Couleur des barres
    )

    println("Meilleur nœud de départ (Prim): ", best_i_prim)
    println("Poids minimal obtenu: ", best_poids_prim)
    
    # Enregistrement de l'histogramme
    #savefig("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/"*filename*"_prim_histo_RSL.png")

    # Initialisation
    dif_val_tournee_kruskal = Vector{Float64}(undef, length(start_node_vec))  # Vecteur pour stocker les différences
    best_i_kruskal = nothing
    best_poids_kruskal = Inf

    # Calcul des poids minimaux pour chaque nœud de départ
    for (i, start_node) in enumerate(start_node_vec)
        _, poids_minimal = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, start_node, 1)
        println("poids_minimal = ", poids_minimal)

        # Calcul de la différence        
        dif_val_tournee_kruskal[i] = poids_minimal - stsp_weight
        
        # Mise à jour du meilleur poids
        if poids_minimal < best_poids_kruskal
            best_i_kruskal = i 
            best_poids_kruskal = poids_minimal
        end
    end
    
    # Création de l'histogramme
    bar(
        [i for i in 1:length(dif_val_tournee_kruskal)],                   # Indices des nœuds en abscisse
        dif_val_tournee_kruskal,             # Valeurs des différences en ordonnée
        xlabel="Nœud de départ",         # Nom de l'axe X
        ylabel="Différence (RSL - STSP)", # Nom de l'axe Y
        title="Différences de poids (RSL - STSP) avec Kruskal", # Titre
        legend=false,
        color=:blue                       # Couleur des barres
    )

    # Enregistrement de l'histogramme
    #savefig("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/"*filename*"_kruskal_histo_RSL.png")

    println("Meilleur nœud de départ (Kruskal): = ", best_i_kruskal)
    println("Poids minimal obtenu = ", best_poids_kruskal)

    return best_i_prim, best_poids_prim, best_i_kruskal, best_poids_kruskal

end

"""
    comparaison_all_RSL()

# Permet d'enregistrer les meilleures paramètres trouvés lors de la recherche avec la méthode RSL.
"""
function comparaison_all_RSL()

    # Obtention des meilleurs paramètres pour les méthodes RSK et HK pour le fichier exemple_phase_4
    best_parameters  = Dict()
    resultats = comparaison_RSL("exemple_phase_4")
    best_parameters["exemple_phase_4"] = Dict("prim" => resultats[1:2], "kruskal" => resultats[3:4])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters_RSL.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    
    # Obtention des meilleurs paramètres pour les méthodes RSK et HK pour le fichier gr17
    resultats = comparaison_RSL("gr17")
    best_parameters["gr17"] = Dict("prim" => resultats[1:2], "kruskal" => resultats[3:4])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters_RSL.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end

    # Obtention des meilleurs paramètres pour les méthodes RSK et HK pour le fichier gr21
    resultats = comparaison_RSL("gr21")
    best_parameters["gr21"] = Dict("prim" => resultats[1:2], "kruskal" => resultats[3:4])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters_RSL.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    
    # Obtention des meilleurs paramètres pour les méthodes RSK et HK pour le fichier gr24
    resultats = comparaison_RSL("gr24")
    best_parameters["gr24"] = Dict("prim" => resultats[1:2], "kruskal" => resultats[3:4])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters_RSL.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    
    # Obtention des meilleurs paramètres pour les méthodes RSK et HK pour le fichier fri26
    resultats = comparaison_RSL("fri26")
    best_parameters["fri26"] = Dict("prim" => resultats[1:2], "kruskal" => resultats[3:4])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters_RSL.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    
    # Obtention des meilleurs paramètres pour les méthodes RSK et HK pour le fichier dantzig42
    resultats = comparaison_RSL("dantzig42")
    best_parameters["dantzig42"] = Dict("prim" => resultats[1:2], "kruskal" => resultats[3:4])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters_RSL.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    
    # Obtention des meilleurs paramètres pour les méthodes RSK et HK pour le fichier swiss42
    resultats = comparaison_RSL("swiss42")
    best_parameters["swiss42"] = Dict("prim" => resultats[1:2], "kruskal" => resultats[3:4])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters_RSL.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    
    # Obtention des meilleurs paramètres pour les méthodes RSK et HK pour le fichier gr48
    resultats = comparaison_RSL("gr48")
    best_parameters["gr48"] = Dict("prim" => resultats[1:2], "kruskal" => resultats[3:4])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters_RSL.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    
    # Obtention des meilleurs paramètres pour les méthodes RSK et HK pour le fichier hk48
    resultats = comparaison_RSL("hk48")
    best_parameters["hk48"] = Dict("prim" => resultats[1:2], "kruskal" => resultats[3:4])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters_RSL.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end

    # Obtention des meilleurs paramètres pour les méthodes RSK et HK pour le fichier bayg29
    resultats = comparaison_RSL("bayg29")
    best_parameters["bayg29"] = Dict("prim" => resultats[1:2], "kruskal" => resultats[3:4])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters_RSL.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    
    # Obtention des meilleurs paramètres pour les méthodes RSK et HK pour le fichier bays29
    resultats = comparaison_RSL("bays29")
    best_parameters["bays29"] = Dict("prim" => resultats[1:2], "kruskal" => resultats[3:4])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters_RSL.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    
    # Obtention des meilleurs paramètres pour les méthodes RSK et HK pour le fichier brazil58
    resultats = comparaison_RSL("brazil58")
    best_parameters["brazil58"] = Dict("prim" => resultats[1:2], "kruskal" => resultats[3:4])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters_RSL.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
end
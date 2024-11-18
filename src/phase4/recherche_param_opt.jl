using STSP 

export comparaison, comparaison_all

function comparaison(filename::String, valeur_comp::Int64)
    
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

    p = heatmap(
        pas_vec,                    
        start_node_vec,            
        dif_val_tournee_prim,   
        color=cgrad([:green,:yellow]), 
        clim = (0,valeur_comp),
        xlabel="pas", ylabel="Noeud de départ",
        title="Différences de poids (HK - STSP) avec Prim",
        xscale=:log10 
    )

    savefig("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/"*filename*"_prim.png")

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

    p = heatmap(
        pas_vec,                    
        start_node_vec,            
        dif_val_tournee_kruskal,   
        color=cgrad([:green,:yellow]), 
        clim = (0,valeur_comp),
        xlabel="pas", ylabel="Noeud de départ",
        title="Différences de poids (HK - STSP) avec Kruskal",
        xscale=:log10 
    )

    savefig("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/"*filename*"_kruskal.png")

    println("best_i = ", best_i_kruskal)
    println("best_pas = ", best_pas_kruskal)
    println("best_poids = ", best_poids_kruskal)

    return best_i_prim, best_pas_prim, best_poids_prim, best_i_kruskal, best_pas_kruskal, best_poids_kruskal

end

function comparaison_all()
    best_parameters  = Dict()
    resultats = comparaison("exemple_phase_4", 1)
    best_parameters["exemple_phase_4"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison("gr17", 150)
    best_parameters["gr17"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison("gr21", 150)
    best_parameters["gr21"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison("gr24", 150)
    best_parameters["gr24"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison("fri26", 150)
    best_parameters["fri26"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison("dantzig42", 300)
    best_parameters["dantzig42"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison("swiss42", 300)
    best_parameters["swiss42"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison("gr48", 2000)
    best_parameters["gr48"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison("hk48", 2700)
    best_parameters["hk48"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison("bayg29", 300)
    best_parameters["bayg29"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    resultats = comparaison("bays29", 300)
    best_parameters["bays29"] = Dict("prim" => resultats[1:3], "kruskal" => resultats[4:6])
    # Ouvrir un fichier et écrire
    open("C:/Users/Giorgi/Desktop/dossier_latex/Projet_MTH/best_parameters.txt", "w") do file
        for (key, value) in best_parameters
            println(file, "$key: $value")
        end
    end
    return best_parameters
end
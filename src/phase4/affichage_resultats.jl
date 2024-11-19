using STSP, Printf

export affichage_resultats_param_opt

function affichage_resultats_param_opt()

    # Pour exemple_phase_4.tsp
    graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/exemple_phase_4.tsp")
    println("Pour le fichier exemple_phase_4.tsp :")
    _, poids_minimal_HK = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 1, 1, 0.1, 2500, 100000)
    _, poids_minimal_RSL = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 1, 1)
    poids_tournee_opt = get_instance_weight("exemple_phase_4")
    println(" ")
    println("Résultats obtenus : Poids minimal théorique : $poids_tournee_opt")
    println("Résultats obtenus : Poids minimal avec RSL : $poids_minimal_RSL | Poids minimal avec HK : $poids_minimal_HK")
    RSL_er = round(((poids_minimal_RSL - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    HK_er = round(((poids_minimal_HK - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    # Affichage formaté
    println(@sprintf("Erreur relative (en %%): Avec RSL : %.1f%% | Avec HK : %.1f%% | formule = (poids_minimal_trouve - poids_tournee_opt)/poids_tournee_opt", RSL_er, HK_er))
    
    # Pour bayg29.tsp
    graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/bayg29.tsp")
    println("Pour le fichier bayg29.tsp :")
    _, poids_minimal_HK = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 16, 2, 1.2, 2500, 100000)
    _, poids_minimal_RSL = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 17, 1)
    poids_tournee_opt = get_instance_weight("bayg29")
    println(" ")
    println("Résultats obtenus : Poids minimal théorique : $poids_tournee_opt")
    println("Résultats obtenus : Poids minimal avec RSL : $poids_minimal_RSL | Poids minimal avec HK : $poids_minimal_HK")
    RSL_er = round(((poids_minimal_RSL - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    HK_er = round(((poids_minimal_HK - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    # Affichage formaté
    println(@sprintf("Erreur relative (en %%): Avec RSL : %.1f%% | Avec HK : %.1f%% | formule = (poids_minimal_trouve - poids_tournee_opt)/poids_tournee_opt", RSL_er, HK_er))

    # Pour bays29.tsp
    graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/bays29.tsp")
    println("Pour le fichier bays29.tsp :")
    _, poids_minimal_HK = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 16, 2, 1.6, 2500, 100000)
    _, poids_minimal_RSL = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 14, 1)
    poids_tournee_opt = get_instance_weight("bays29")
    println(" ")
    println("Résultats obtenus : Poids minimal théorique : $poids_tournee_opt")
    println("Résultats obtenus : Poids minimal avec RSL : $poids_minimal_RSL | Poids minimal avec HK : $poids_minimal_HK")
    RSL_er = round(((poids_minimal_RSL - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    HK_er = round(((poids_minimal_HK - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    # Affichage formaté
    println(@sprintf("Erreur relative (en %%): Avec RSL : %.1f%% | Avec HK : %.1f%% | formule = (poids_minimal_trouve - poids_tournee_opt)/poids_tournee_opt", RSL_er, HK_er))
    
    # Pour dantzig42.tsp
    graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/dantzig42.tsp")
    println("Pour le fichier dantzig42.tsp :")
    _, poids_minimal_HK = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 30, 2, 0.6, 2500, 100000)
    _, poids_minimal_RSL = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 21, 2)
    poids_tournee_opt = get_instance_weight("dantzig42")
    println(" ")
    println("Résultats obtenus : Poids minimal théorique : $poids_tournee_opt")
    println("Résultats obtenus : Poids minimal avec RSL : $poids_minimal_RSL | Poids minimal avec HK : $poids_minimal_HK")
    RSL_er = round(((poids_minimal_RSL - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    HK_er = round(((poids_minimal_HK - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    # Affichage formaté
    println(@sprintf("Erreur relative (en %%): Avec RSL : %.1f%% | Avec HK : %.1f%% | formule = (poids_minimal_trouve - poids_tournee_opt)/poids_tournee_opt", RSL_er, HK_er))
    
    # Pour fri26.tsp
    graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/fri26.tsp")
    println("Pour le fichier fri26.tsp :")
    _, poids_minimal_HK = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 2, 1, 0.1, 2500, 100000)
    _, poids_minimal_RSL = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 12, 1)
    poids_tournee_opt = get_instance_weight("fri26")
    println(" ")
    println("Résultats obtenus : Poids minimal théorique : $poids_tournee_opt")
    println("Résultats obtenus : Poids minimal avec RSL : $poids_minimal_RSL | Poids minimal avec HK : $poids_minimal_HK")
    RSL_er = round(((poids_minimal_RSL - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    HK_er = round(((poids_minimal_HK - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    # Affichage formaté
    println(@sprintf("Erreur relative (en %%): Avec RSL : %.1f%% | Avec HK : %.1f%% | formule = (poids_minimal_trouve - poids_tournee_opt)/poids_tournee_opt", RSL_er, HK_er))
    
    # Pour gr17.tsp
    graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/gr17.tsp")
    println("Pour le fichier gr17.tsp :")
    _, poids_minimal_HK = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 4, 2, 0.2, 2500, 100000)
    _, poids_minimal_RSL = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 7, 1)
    poids_tournee_opt = get_instance_weight("gr17")
    println(" ")
    println("Résultats obtenus : Poids minimal théorique : $poids_tournee_opt")
    println("Résultats obtenus : Poids minimal avec RSL : $poids_minimal_RSL | Poids minimal avec HK : $poids_minimal_HK")
    RSL_er = round(((poids_minimal_RSL - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    HK_er = round(((poids_minimal_HK - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    # Affichage formaté
    println(@sprintf("Erreur relative (en %%): Avec RSL : %.1f%% | Avec HK : %.1f%% | formule = (poids_minimal_trouve - poids_tournee_opt)/poids_tournee_opt", RSL_er, HK_er))

    # Pour gr21.tsp
    graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/gr21.tsp")
    println("Pour le fichier gr21.tsp :")
    _, poids_minimal_HK = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 13, 1, 10.0, 2500, 100000)
    _, poids_minimal_RSL = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 14, 1)
    poids_tournee_opt = get_instance_weight("gr21")
    println(" ")
    println("Résultats obtenus : Poids minimal théorique : $poids_tournee_opt")
    println("Résultats obtenus : Poids minimal avec RSL : $poids_minimal_RSL | Poids minimal avec HK : $poids_minimal_HK")
    RSL_er = round(((poids_minimal_RSL - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    HK_er = round(((poids_minimal_HK - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    # Affichage formaté
    println(@sprintf("Erreur relative (en %%): Avec RSL : %.1f%% | Avec HK : %.1f%% | formule = (poids_minimal_trouve - poids_tournee_opt)/poids_tournee_opt", RSL_er, HK_er))

    # Pour gr24.tsp
    graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/gr24.tsp")
    println("Pour le fichier gr24.tsp :")
    _, poids_minimal_HK = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 23, 1, 10.0, 2500, 100000)
    _, poids_minimal_RSL = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 24, 1)
    poids_tournee_opt = get_instance_weight("gr24")
    println(" ")
    println("Résultats obtenus : Poids minimal théorique : $poids_tournee_opt")
    println("Résultats obtenus : Poids minimal avec RSL : $poids_minimal_RSL | Poids minimal avec HK : $poids_minimal_HK")
    RSL_er = round(((poids_minimal_RSL - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    HK_er = round(((poids_minimal_HK - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    # Affichage formaté
    println(@sprintf("Erreur relative (en %%): Avec RSL : %.1f%% | Avec HK : %.1f%% | formule = (poids_minimal_trouve - poids_tournee_opt)/poids_tournee_opt", RSL_er, HK_er))

    # Pour gr48.tsp
    graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/gr48.tsp")
    println("Pour le fichier gr48.tsp :")
    _, poids_minimal_HK = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 26, 2, 1.4, 2500, 100000)
    _, poids_minimal_RSL = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 4, 2)
    poids_tournee_opt = get_instance_weight("gr48")
    println(" ")
    println("Résultats obtenus : Poids minimal théorique : $poids_tournee_opt")
    println("Résultats obtenus : Poids minimal avec RSL : $poids_minimal_RSL | Poids minimal avec HK : $poids_minimal_HK")
    RSL_er = round(((poids_minimal_RSL - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    HK_er = round(((poids_minimal_HK - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    # Affichage formaté
    println(@sprintf("Erreur relative (en %%): Avec RSL : %.1f%% | Avec HK : %.1f%% | formule = (poids_minimal_trouve - poids_tournee_opt)/poids_tournee_opt", RSL_er, HK_er))

    # Pour swiss42.tsp
    graph_nodes, graph_edges, edge_weights_dict = read_stsp("../instances/stsp/swiss42.tsp")
    println("Pour le fichier swiss42.tsp :")
    _, poids_minimal_HK = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 39, 1, 0.1, 2500, 100000)
    _, poids_minimal_RSL = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 32, 1)
    poids_tournee_opt = get_instance_weight("swiss42")
    println(" ")
    println("Résultats obtenus : Poids minimal théorique : $poids_tournee_opt")
    println("Résultats obtenus : Poids minimal avec RSL : $poids_minimal_RSL | Poids minimal avec HK : $poids_minimal_HK")
    RSL_er = round(((poids_minimal_RSL - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    HK_er = round(((poids_minimal_HK - poids_tournee_opt) / poids_tournee_opt) * 100, digits=1)
    # Affichage formaté
    println(@sprintf("Erreur relative (en %%): Avec RSL : %.1f%% | Avec HK : %.1f%% | formule = (poids_minimal_trouve - poids_tournee_opt)/poids_tournee_opt", RSL_er, HK_er))
end
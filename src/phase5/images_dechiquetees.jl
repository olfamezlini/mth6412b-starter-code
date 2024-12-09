using STSP
export construction_image

"""Write a tour in TSPLIB format."""
function write_tour1(filename::String, tour::Array{Int}, cost::Float32, algo::Int64)
	file = open(filename, "w")
	length_tour = length(tour)
	write(file,"NAME : $filename\n")
	#Date=Dates.format(Dates.now(),"e u d H:M:S Y")
	write(file,"COMMENT : LENGHT = $cost\n")
    #if algo ==1
        #write(file,"COMMENT : Found by LKH [Keld Helsgaun] $Date \n")
    #else  algo ==2
        #write(file,"COMMENT : Found by RSL [Rosenkrantz, Stearns et Lewis] $Date \n")
    #end
	write(file,"TYPE : TOUR\n")
	write(file,"DIMENSION : $length_tour\n")
	write(file,"TOUR_SECTION\n")
	for node in tour
		write(file, "$(node)\n")
	end
	write(file, "-1\nEOF\n")
	close(file)
end

"""
    (instance::String, methode_TSP::String, methode_arbre::String, pas::Int, periode::Int, limite::Int)

...
# Arguments
- `instance::String`: Nom de l'instance photo considérée
- `methode_TSP::String`: Nom de la méthode pour résoudre le problème du voyageur (RSL ou HK)
- `methode_arbre::String`: Nom de la méthode pour trouver les arbres minimaux (Kruskal ou Prim)
- `pas::Int`: Pas pour la méthode HK
- `periode::Int`: Nombre de répétition de la "meilleure" solution trouvée pour HK
- `limite::Int`: Limite maximale du nombre d'itération pour la méthode HK
...

applique les différentes méthodes et construit les images grâce aux tournées trouvées.
"""
function construction_image(instance::String, methode_TSP::String, methode_arbre::String, pas::Float64, periode::Int64, limite::Int64)

	filename = "../shredder-julia/tsp/instances/$instance.tsp"
	tour_filename = "phase5/Tour/{$instance}_{$methode_TSP}_{$methode_arbre}.tour"
	input_filename = "../shredder-julia/images/shuffled/$instance.png"
	output_name = "phase5/Tour/{$instance}_{$methode_TSP}_{$methode_arbre}.png" 

	graph_nodes, graph_edges, edge_weights_dict = read_stsp(filename)

	graph_edges = complete_graph_edges(graph_edges)

	edge_weights_dict = Dict(k => BigFloat(v) for (k, v) in edge_weights_dict)

	add_symmetry!(edge_weights_dict)

	edge_weights_dict = Dict(k => Float64(v) for (k, v) in edge_weights_dict)

	if methode_TSP == "RSL" && methode_arbre == "Kruskal"
		graph, poids, tour = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 1, 1)
	elseif methode_TSP == "RSL" && methode_arbre == "Prim"
		graph, poids, tour = Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 1, 2)
	elseif methode_TSP == "HK" && methode_arbre == "Kruskal"
		if instance == "nikos-cat"
			graph, poids, tour=Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 1, 1, 10.0, 10, 100000)
		elseif instance == "lower-kananaskis-lake"
			graph, poids, tour=Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 1, 1, 1.0, 50, 100000)
		elseif instance == "tokyo-skytree-aerial"			
			graph, poids, tour=Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 1, 1, 10.0, 10, 100000)
		elseif instance == "abstract-light-painting" || instance == "the-enchanted-garden"
			graph, poids, tour=Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 1, 1, 1.0, 500, 100000)
		else
			graph, poids, tour=Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 1, 1, pas, periode, limite)
		end
	elseif methode_TSP == "HK" && methode_arbre == "Prim"
		graph, poids, tour = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 1, 2, 10.0, 10, 100000)
	else
		println("Noms invalides !")
	end

	write_tour1(tour_filename, Array(tour[1:end-1]), Float32(poids), 1)

	reconstruct_picture(tour_filename, input_filename, output_name)
end
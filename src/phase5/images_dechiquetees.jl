using STSP
export write_tour1

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


graph_nodes, graph_edges, edge_weights_dict = read_stsp("../shredder-julia/tsp/instances/alaska-railroad.tsp")

graph_edges = complete_graph_edges(graph_edges)

println(length(edge_weights_dict))

println(length(graph_edges))

edge_weights_dict = Dict(k => BigFloat(v) for (k, v) in edge_weights_dict)

add_symmetry!(edge_weights_dict)

edge_weights_dict = Dict(k => Float64(v) for (k, v) in edge_weights_dict)


graph, poids, tour=Algorithme_RSL(graph_nodes, graph_edges, edge_weights_dict, 1, 1)

#graph, poids, tour=Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 545, 1, 10.0, 10, 100000)

write_tour1("phase5/Tour/alaska-railroad.tour", Array(tour[1:end-1]), Float32(poids),1)




reconstruct_picture("phase5/Tour/alaska-railroad.tour", "../shredder-julia/images/shuffled/alaska-railroad.png", "phase5/Tour/alaska-railroad.png" )

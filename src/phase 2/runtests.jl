# Importation des fichiers nécessaires

include("main.jl")

using Test

@testset "algortihme_kruskal" begin
  graph_nodes, graph_edges, edge_weights_dict = read_stsp("instances/stsp/exemple_phase_2.tsp");
  arbre_minimal, poids_minimal = Algortihme_Kruskal(graph_edges, edge_weights_dict);
  @test poids_minimal==37
  @test typeof(arbre_minimal)==Graph{Int64, Int64}
end
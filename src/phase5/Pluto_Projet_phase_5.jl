### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 466b1feb-e208-4738-be70-733511fb3b6a
using Images

# ╔═╡ d66ffa51-1c09-43c5-86d5-c00ee61609b1
md"""#### Importation des modules nécessaires"""

# ╔═╡ 72ba7e00-8358-11ef-3c2a-73d1b7473118
md"""## Giorgi Gamkrelidze - Matricule : 2408995
## Olfa Mezlini - Matricule : 2327229
## Projet phase 5"""

# ╔═╡ 35ce874f-0c25-4ea3-ad96-837a7d262806
md"""#### Lien de la phase 5 sur Github : [https://github.com/olfamezlini/mth6412b-starter-code](https://github.com/olfamezlini/mth6412b-starter-code)"""

# ╔═╡ 84284d95-aac1-4816-81db-c61643359868
md"""##### La dernière partie du projet consiste à mettre notre méthode de résolution du TSP en oeuvre afin de reconstruire des images déchiquetées."""

# ╔═╡ cda23dde-a296-4778-bbff-57667e8151a4
md"""
Le but de cette phase est de reconstruire les images le mieux possible. Cela peut se faire à l’aide du TSP en imaginant que chaque bande verticale représente un noeud du graphe complet, et le poids de chaque arête est une mesure de dissimilarité entre deux bandes verticales. L’idée consiste à supposer que dans l’image originale, deux bandes adjacentes sont très semblables, i.e., très peu dissemblables. On cherche ainsi un chemin simple de longueur maximale à travers les noeuds du graphe, qui est aussi de poids minimal. Comme nous l’avons vu en classe, ce problème est équivalent au TSP. 
"""

# ╔═╡ 4084b55e-1197-43bd-9351-900f228f3474
md"""
Pour chaque image déchiquetée, un fichier tsp a déjà été créé dans le répertoire tsp/instances . Un noeud fictif (numéro zéro) a été ajouté ainsi qu’une arête de poids nul reliant ce noeud fictif à chaque autre noeud du graphe. Afin de prendre en considération ces modifications dans les fichiers tsp doivent être lus avec une version mise à jour de read_stsp.jl. La ligne ( if weight != 0 || filename[4:5]=="sh" ) du code a été modifié pour satisfaire la condition sur la lecture de noeud fictif.
"""

# ╔═╡ 4af0273a-d086-40b2-b7f7-f40540a6a03a
begin
	"""Renvoie les noeuds et les arêtes du graphe."""
	function read_stsp(filename::String)
	  Base.print("Reading of header : ")
	  header = read_header(filename)
	  println("✓")
	  dim = parse(Int, header["DIMENSION"])
	  edge_weight_format = header["EDGE_WEIGHT_FORMAT"]
	
	  Base.print("Reading of nodes : ")
	  graph_nodes = read_nodes(header, filename)
	  println("✓")
	
	  Base.print("Reading of edges : ")
	  edges_brut, edge_weights = read_edges(header, filename)
	  graph_edges = [Int[] for _ in 1:dim]
	  edge_weights_dict = Dict{Tuple{Int, Int}, Float64}()
	
	  for (index, edge) in enumerate(edges_brut)
	      weight = edge_weights[index]
	      if weight != 0 || filename[4:5]=="sh"
	        if edge_weight_format in ["UPPER_ROW", "LOWER_COL", "UPPER_DIAG_ROW", "LOWER_DIAG_COL"]
	            push!(graph_edges[edge[1]], edge[2])
	            edge_weights_dict[(edge[1], edge[2])] = weight
	        else
	            push!(graph_edges[edge[2]], edge[1])
	            edge_weights_dict[(edge[2], edge[1])] = weight
	        end
	      end
	  end
	
	  for k = 1 : dim
	      graph_edges[k] = sort(graph_edges[k])
	  end
	  println("✓")
	
	  return graph_nodes, graph_edges, edge_weights_dict
	end
end

# ╔═╡ 75e4a0e5-0864-4cf7-ae57-5ae61c300d89
md"""
En utilisant et adaptant les differents codes des fonction dans tools.jl nous avons codé la fonction construction-image qui cherche une tournée minimale sur Le graphe modifié. Vous voyez ci-dissous les diff!rents argumets de la fonction et ses détails de fonctionnement.
Pour chaque image reconstruite, la fonction donne la longueur de la meilleure tournée trouvée, l’image originale ainsi que l’image reconstruite côte-à-côte.
"""

# ╔═╡ 7aff023f-2808-4a0d-8820-f0b6ef754f86
"""
    construction_image(instance::String, methode_TSP::String, methode_arbre::String, pas::Float64, periode::Int64, limite::Int64)


# Arguments
- `instance::String`: Nom de l'instance photo considérée
- `methode_TSP::String`: Nom de la méthode pour résoudre le problème du voyageur (RSL ou HK)
- `methode_arbre::String`: Nom de la méthode pour trouver les arbres minimaux (Kruskal ou Prim)
- `pas::Int`: Pas pour la méthode HK
- `periode::Int`: Nombre de répétition de la "meilleure" solution trouvée pour HK
- `limite::Int`: Limite maximale du nombre d'itération pour la méthode HK

# Reconstruire des images déchiquetées

Applique les différentes méthodes et construit les images grâce aux tournées trouvées.
"""
begin
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
			graph, poids, tour=Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 1, 1, pas, periode, limite)
		elseif methode_TSP == "HK" && methode_arbre == "Prim"
			graph, poids, tour = Algorithme_HK(graph_nodes, graph_edges, edge_weights_dict, 1, 2, pas, periode, limite)
		end
	
		write_tour1(tour_filename, Array(tour[1:end-1]), Float32(poids), 1)
		reconstruct_picture(tour_filename, input_filename, output_name)
		println("Poids minimal : ", poids)
	end
end

# ╔═╡ 855f6dab-3688-48ac-9f50-47bedaf0cc07
md"""
##### Reconstruction des images
"""

# ╔═╡ 9fdd0d2e-cb69-4695-be7a-427ae81ea18a
md"""
Dans le cadre de ce projet, nous avons travaillé sur 9 images déchiquetées. Grâce à l'application des algorithmes et outils développés, nous avons obtenu des résultats encourageants : 5 images ont été parfaitement reconstruites (solutions optimales), tandis que 4 autres ont été reconstruites avec une précision quasi optimale.
"""

# ╔═╡ 37c07894-11c2-49c1-ae1e-81b85b53d431
md"""
Nous avons mis en œuvre les algorithmes RSL et HK pour résoudre le problème : 

- RSL : Méthode heuristique, rapide mais approximative.
- HK : Algorithme plus précis, mais plus coûteux en temps de calcul.
"""

# ╔═╡ eb9b2a22-1f01-4753-abb5-065a020f6cae
md"""
Dans la section suivante, nous présenterons un exemple concret en traitant le cas "nikos-cat". Nous avons débuté par une résolution à l'aide de l'algorithme RSL, mais les résultats obtenus n'étant pas probants, nous avons décidé de poursuivre nos efforts en utilisant l'algorithme HK. Ce processus progressif nous a permis d'atteindre le résultat optimal pour cette instance.
"""

# ╔═╡ dc3a35f3-ceaf-4753-a7d0-999a74fcc028


# ╔═╡ 4d8a9765-6c06-4fbd-afae-d8bcbc84707d


# ╔═╡ 1c6cddb3-221e-4402-b3a1-c3ad7cb98d55


# ╔═╡ 74c31eec-4401-4119-95bd-f8493a9bbd6e
md"""######  Cas "nikos-cat"
"""

# ╔═╡ 7779394e-ac29-4967-9f4b-8b7b7fd7e933
nikos_cat_RSL = load("C:/Users/olfam/mth6412b-starter-code/src/figures/{nikos-cat}_{RSL}_{Kruskal}.png")

# ╔═╡ 14139516-8a6e-441d-bc2c-7e1edb0f6dc5
md"""
Poids de la tournée = $4.334863 \times 10^6$   |  Erreur relative = 42.7502%
"""

# ╔═╡ 570eb5ad-b330-4d09-83ea-2dc4ea03ac4a
nikos_cat_HK_Prim = load("C:/Users/olfam/mth6412b-starter-code/src/figures/{nikos-cat}_{HK}_{Prim}.png")

# ╔═╡ 448f7c3f-33b1-4a65-86e8-02cc1721a6ee
md"""
Poids de la tournée = $3.088146 \times 10^6$   |  Erreur relative = 1.6949%
"""

# ╔═╡ 68c24d12-7267-45e3-bb92-09c57560b5df
nikos_cat_HK_Kruskal_OPTIMAL = load("C:/Users/olfam/mth6412b-starter-code/src/figures/{nikos-cat}_{HK}_{Kruskal}.png")

# ╔═╡ a7270d6a-0df7-4a2f-ac6b-48150d4ad985
md"""
Poids de la tournée = $3.036676 \times 10^6$   |  Erreur relative = 0%
"""

# ╔═╡ f854f842-0ba9-4793-b288-f3963a9ba2c4


# ╔═╡ 4fc77218-d837-4354-b682-9f7f6840b403


# ╔═╡ c74ab586-6300-4312-9ed8-304ed9d47a36


# ╔═╡ 0bb7945a-c7d1-4697-8669-ea7b61ab161e


# ╔═╡ 1e9947b9-208e-4a24-ae58-d4084666bab9


# ╔═╡ 4bb6aa63-7d4e-4a54-a0ad-6212480aedaf


# ╔═╡ 0b0611a5-ee64-48a5-918e-dcb1fcf9392c


# ╔═╡ 657b4eb8-ceb0-44b2-a5d4-ab80c7979d7a


# ╔═╡ 9273b354-f62f-491c-b555-f76704ddb117


# ╔═╡ 219088aa-53e3-4cc0-8e7f-02605890c9c0


# ╔═╡ 78790e55-d2dd-4711-9617-203ec5d9f9bf


# ╔═╡ 702ced6f-78f8-41ab-b8df-e0c3017f721a


# ╔═╡ 1cff311a-3dcb-4460-8060-aa48bcd921ea


# ╔═╡ 3ecd61be-b9e6-4e50-b872-7520c4cc737a
md"""######  Cas "blue-hour-paris"
"""

# ╔═╡ a96fca5e-3d84-410c-95e5-b85d2c601d00
md"""
Pour le cas "blue-hour-paris", nous avons utilisé l'algorithme HK et obtenu un résultat que nous qualifions de quasi optimal, en nous basant sur une comparaison directe avec l'image originale. Cette évaluation a permis de constater que, bien que la reconstruction soit très proche de l'originale, elle présente de légères différences, justifiant l'écart par rapport à la tournée optimale.
"""

# ╔═╡ a5c6a0fe-6e0c-467a-b264-1581aee724b2
blue_hour_paris_HK = load("C:/Users/olfam/mth6412b-starter-code/src/figures/{blue-hour-paris}_{HK}_{Kruskal}.png")

# ╔═╡ d09d7a36-b427-4e68-b090-f5bee5c46f2f
md"""
Poids de la tournée = $4.026104 \times 10^6$  |  Erreur relative = 2.0156%
"""

# ╔═╡ b43d4c6d-34b9-4737-8c82-073d582efe89


# ╔═╡ c96682bc-184a-4060-a2a5-8a0769c0a6ec


# ╔═╡ 56cb5413-4dcf-4c38-b870-ce599446351d


# ╔═╡ 106e55ee-bc2a-43a6-a845-f352c0c14f03


# ╔═╡ 6382a40f-44ca-447d-8f66-dc09c82c4859


# ╔═╡ 64795c75-d73d-4783-a6db-a27ce7c508f4


# ╔═╡ 4fa90df6-10e3-4373-85be-37b58f6161b3


# ╔═╡ ccb8c00e-4d76-4f61-b91b-96c38acf57cc


# ╔═╡ 62c61a0f-24b2-4e18-bd48-33aa7da86de6


# ╔═╡ 33f711d8-6adb-46e9-b62f-f1ac91bf7a18
md"""######  Cas "abstract-light-painting"
"""

# ╔═╡ dd939590-aa6d-44a2-adc3-206456e53d82
md"""
Pour le cas "abstract-light-painting", nous avons réussi à atteindre une solution optimale en utilisant l'algorithme Hk et un bon jeu de paramèter. La reconstruction obtenue correspond parfaitement à l'image originale, ce qui confirme la qualité de la tournée trouvée.
"""

# ╔═╡ 4a9cb1f5-1e23-4550-9957-6cb8c0cb6c44
abstract_light_painting_HK = load("C:/Users/olfam/mth6412b-starter-code/src/figures/{abstract-light-painting}_{HK}_{Kruskal}.png")

# ╔═╡ 311617f9-20ca-455f-b5a7-ff48f991c25c
md"""
Poids de la tournée = $1.2314767 \times 10^7$  |  Erreur relative = 0%
"""

# ╔═╡ dfe69cfe-447c-41a5-b13e-af9a4aaf5705


# ╔═╡ efa810db-cc21-401d-9ca8-f8ccf7c16a60


# ╔═╡ 0ad51475-558d-4afa-acee-cf0ee2b1ac89


# ╔═╡ e8f07802-39e7-4a60-b7df-d5310cd6f193


# ╔═╡ 59558c2f-aac4-447c-be7c-ce64e900bf2d


# ╔═╡ d9cbe652-6298-4030-82ea-9575f505edcb


# ╔═╡ 3108597f-a618-42e8-bd66-d03e5ca472dc


# ╔═╡ c874b86b-a4c2-4d94-a6ce-52bcc2eb804a


# ╔═╡ 1b3a5265-0764-4916-802c-0b8b6eeb846a


# ╔═╡ c7080e3a-4105-4e00-afa5-b3d7e21363b5


# ╔═╡ 0e1148e0-3182-48e9-ad29-9488cb9fa178
md"""######  Cas "alaska-railroad"
"""

# ╔═╡ c00abd35-6214-46c3-bc89-040fd51a60fb
md"""
Pour le cas "Alaska-railroad", le meilleur résultat obtenu présente une correspondance parfaite avec l’original pour la moitié de l’image. Cependant, l’autre moitié montre des écarts, ce qui indique que la solution trouvée est partiellement alignée avec l’optimum.
"""

# ╔═╡ 2ae5564e-ed04-4427-8e98-716aa30ffef5
alaska_railroad_HK = load("C:/Users/olfam/mth6412b-starter-code/src/figures/{alaska-railroad}_{HK}_{Kruskal}.png")

# ╔═╡ e8ba6a27-1af9-484e-b2e2-4757b929ebf4
md"""
Poids de la tournée = $7.701385 \times 10^6$  |  Erreur relative = 4.7563%
"""

# ╔═╡ fd44eb04-9b42-4f96-abd0-a4cd9c885938


# ╔═╡ a125d641-ea48-4b02-9251-90b93e65ff92


# ╔═╡ 8ad95a68-ea3a-4382-897c-683548faed66


# ╔═╡ 1ab467bf-950e-43ab-92cb-eea0f57b3611


# ╔═╡ a131d94c-d87c-461d-8b35-6c36272471ef


# ╔═╡ d0f59290-7de4-4dd5-9add-7901605eafed


# ╔═╡ 3219563c-80c1-4172-9fbf-9ab09cdfd552


# ╔═╡ a9530888-3461-44e3-9e26-b92d297d2e6d


# ╔═╡ 543c9b4a-65b3-4776-8160-709b0eafbb30


# ╔═╡ d372541c-5c51-471d-b219-ca25e6672afb
md"""######  Cas "lower-kananaskis-lake"
"""

# ╔═╡ 18b8c4f1-1a1c-44f3-960b-0868a6b6e719
md"""
Pour le cas "lower-kananaskis-lake", nous avons obtenu une correspondance parfaite avec l'image originale.
"""

# ╔═╡ ff0abfd7-50e3-49f7-b88f-db927c5474dd
lower_kananaskis_lake_HK_OPTIMAL = load("C:/Users/olfam/mth6412b-starter-code/src/figures/{lower-kananaskis-lake}_{HK}_{Kruskal}.png")

# ╔═╡ 0b57d5ec-2a0b-4125-97ae-93d059c8f7d7
md"""
Poids de la tournée = $4.226754 \times 10^6$  |  Erreur relative = 0%
"""

# ╔═╡ c7e204ef-2772-4a68-a23c-43f19ceea55c


# ╔═╡ 9e37bdad-3373-4019-8dee-44afc17f64c9


# ╔═╡ 546366c7-0852-4a52-aa7e-92bc2a9dcfaa


# ╔═╡ 899f8966-5f06-4555-94c5-abf9f23428b2


# ╔═╡ 56bda6d6-93f4-4e78-a18d-d3040739f042


# ╔═╡ e0c3dbbd-53ee-4289-94d7-3f14c39ea581


# ╔═╡ 53115341-43bc-4228-8912-b2d8a4327e0c


# ╔═╡ 4eafeb10-cd76-4322-b823-e9d9a4a0661a


# ╔═╡ 8415dbb7-00e4-432b-8dc3-635a02b18ef5


# ╔═╡ 655b625c-880a-452c-a2e9-162ea99f11b3


# ╔═╡ 69dbea1c-5279-4817-8e7e-f4fd15772e9a


# ╔═╡ fda066f9-d038-4e53-9a38-6ebc615277f2
md"""######  Cas "marlet2-radio-board"
"""

# ╔═╡ e2b548b2-e90f-4b0e-b729-580014fce745
md"""
Pour le cas "marlet2-radio-board", nous n'avons pas réussi à trouver une tournée optimale, malgré plusieurs tentatives.
"""

# ╔═╡ f64ec907-75bc-4e74-8ee0-4bf40de49f14
marlet2_radio_board_HK = load("C:/Users/olfam/mth6412b-starter-code/src/figures/{marlet2-radio-board}_{HK}_{Kruskal}.png")

# ╔═╡ 29a4425e-8130-40d2-b569-cd855ecc00cb
md"""
Poids de la tournée = $9.01198 \times 10^6$  |  Erreur relative = 1.67809%
"""

# ╔═╡ ba29022f-f125-479e-9de2-b59b89b0c800


# ╔═╡ f33dcd95-ce27-4198-902f-0e175cd9bde6


# ╔═╡ e1d1b176-fc0d-4630-9ca0-3b5952065940


# ╔═╡ 26e5118e-9204-49bc-9a56-cc0c514a94f9


# ╔═╡ ff7b65c2-07e7-4718-be79-d0220f542e0e


# ╔═╡ d2c9d8d6-18a2-4f61-9a44-49957fd04079


# ╔═╡ 86ef17db-c061-4466-becb-ae24236e1efb


# ╔═╡ 59bd251a-f431-4a97-8ba9-da0741826c11


# ╔═╡ 76d84762-be6e-42a9-b4ee-7314f7060b7d


# ╔═╡ d90671f6-3f93-4892-8f7a-eaab0fbc8805


# ╔═╡ 19917921-41a1-44da-bc7a-6973104512ab


# ╔═╡ 2db8d6e2-14cf-4d44-beea-d6eeb31c2824
md"""######  Cas "pizza-food-wallpaper"
"""

# ╔═╡ d5894183-2f0b-4abb-84b4-fe0a01474040
md"""
Pour le cas "pizza-food-wallpaper", le meilleur résultat obtenu est le suivant. Nous avons atteint une solution qui, bien qu’elle ne soit pas strictement optimale, offre une reconstruction de haute qualité, démontrant une correspondance visuelle satisfaisante malgré quelques légères imperfections.
"""

# ╔═╡ 732f3808-da57-4901-a820-774e97643c89
pizza_food_wallpaper_HK = load("C:/Users/olfam/mth6412b-starter-code/src/figures/{pizza-food-wallpaper}_{HK}_{Kruskal}.png")

# ╔═╡ a370295e-f607-4cff-87d3-aabfa86a8481
md"""
Poids de la tournée = $5.102007 \times 10^6$  |  Erreur relative = 1.20347%
"""

# ╔═╡ 2934bfe2-f99b-444e-a515-1e0e3c564550


# ╔═╡ de73d800-42a9-453f-8f41-b0e5e41e33b5


# ╔═╡ 9ac6ecfd-6cff-4adc-958b-e97c2400e442


# ╔═╡ 790b47eb-d36c-4813-97b4-69b4fc2245c6


# ╔═╡ d7324566-04b6-41fc-b89b-b8a271c803d2


# ╔═╡ 9e9cee08-abc2-416b-9214-65553af01d0e


# ╔═╡ f5f83673-d736-4ee5-aba8-94955b20912d


# ╔═╡ 09f4e91e-3878-43ac-a999-98411f725b98


# ╔═╡ d4746780-e553-44b2-847a-630683218793


# ╔═╡ eeab4c33-e2cb-4b0f-94f2-f61df40431ff


# ╔═╡ 29392f88-3642-4e0d-8f10-722050b0d592
md"""######  Cas "the-enchanted-garden"
"""

# ╔═╡ baaab24a-b613-4847-bccf-19ecde9053be
md"""
Pour le cas "the-enchanted-garden", nous avons obtenu une correspondance parfaite avec l'image originale.
"""

# ╔═╡ 4936a275-61ef-45ea-aa89-a7883bbcb654
the_enchanted_garden_HK_OPTIMAL = load("C:/Users/olfam/mth6412b-starter-code/src/figures/{the-enchanted-garden}_{HK}_{Kruskal}.png")

# ╔═╡ 084c0f6d-2b99-4e3d-b456-92169ad0ebc7
md"""
Poids de la tournée = $1.99144 \times 10^7$   |  Erreur relative = 0%
"""

# ╔═╡ bd379906-d836-4ee5-beed-b730eb329551


# ╔═╡ cf17b927-06a7-4dae-95d8-e67f2d72301b


# ╔═╡ c7bcd465-bea8-488f-924d-c6803e24eb87


# ╔═╡ 2b29e638-26bb-424b-aff1-ca83c56dd6b3


# ╔═╡ e93d15de-05eb-4fb6-b787-162ec7b8c162


# ╔═╡ 5761d3d6-6ef7-451b-b436-fa04068ad80a


# ╔═╡ 55788670-051e-45f2-95c4-a739a7aa577d


# ╔═╡ f26f6782-a79a-4a94-9836-cee4142a35f2


# ╔═╡ 2705658f-3726-45c3-80b9-8de4612b3cbe


# ╔═╡ 3b035209-d2b3-468e-99f0-8394567bbaa4


# ╔═╡ 634ea18b-5627-457c-9d8e-c998df8b174b
md"""######  Cas "tokyo-skytree-aerial"
"""

# ╔═╡ 71649cb3-0552-4f57-b0c2-bcdd55f38767
md"""
Pour le cas "tokyo-skytree-aerial", nous avons obtenu une correspondance parfaite avec l'image originale.
"""

# ╔═╡ eb5c6985-0558-4306-91ce-00cd88bca949
tokyo_skytree_aerial_HK_OPTIMAL = load("C:/Users/olfam/mth6412b-starter-code/src/figures/{tokyo-skytree-aerial}_{HK}_{Kruskal}.png")

# ╔═╡ f2167acb-a994-4c66-b7fc-923cd5eec91b
md"""
Poids de la tournée = $1.3610038 \times 10^7$ Erreur relative = 0%
"""

# ╔═╡ 27485f3f-eeb8-49f1-b0ea-7ad5b755ff54
md"""
#### Conclusion
"""

# ╔═╡ 967d9492-faa1-4974-9883-a061e684a5cb
md"""
Sur les 9 images analysées, les résultats obtenus montrent l’efficacité des méthodes appliquées. Les 5 reconstructions optimales prouvent la robustesse des algorithmes, tandis que les 4 quasi optimales indiquent des pistes d’amélioration possibles.
"""

# ╔═╡ 615977de-eaae-49cd-aafa-4636cc3d9c42
md"""
Identifier la meilleure tournée pour reconstruire une image fidèle à l’originale est un défi complexe, car cela nécessite de trouver un jeu de paramètre optimal. En effet trouver le jeu de paramètres optimal est crucial, car des petites variations dans ces paramètres peuvent entraîner des différences significatives dans la qualité de la reconstruction.
"""

# ╔═╡ 02462594-d026-4057-9e90-daf95bd8da06
md"""####  Exécution du code sur GitHub"""

# ╔═╡ 54f252f7-d6bd-4f41-a940-8c7cac1589ff
md"""
Pour exécuter le code rendez-vous, dans le fichier mth6412b-starter-code.
Dans le fichier Main.jl, vous trouverez les lignes de commande permettant d'exécuter les algorithmes sur chaque instance avec les paramètres définis, afin de générer les résultats affichés dans ce rapport.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"

[compat]
Images = "~0.26.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.5"
manifest_format = "2.0"
project_hash = "03facbc69ee25220d2e0f4ef883cd193ca312d42"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

    [deps.AbstractFFTs.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "d57bd3762d308bded22c3b82d033bff85f6195c6"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.4.0"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra"]
git-tree-sha1 = "3640d077b6dafd64ceb8fd5c1ec76f7ca53bcf76"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.16.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceCUDSSExt = "CUDSS"
    ArrayInterfaceChainRulesExt = "ChainRules"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceSparseArraysExt = "SparseArrays"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "01b8ccb13d68535d73d2b0c23e39bd23155fb712"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.1.0"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "f21cfd4950cb9f0587d5067e69405ad2acd27b87"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.6"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Static"]
git-tree-sha1 = "5a97e67919535d6841172016c9530fd69494e5ec"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.6"

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "3e4b134270b372f2ed4d4d0e936aabaefc1802bc"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.25.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "05ba0d07cd4fd8b7a39541e31a7b0254704ea581"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.13"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "9ebb045901e9bbf58767a9f34ff89831ed711aae"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.7"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "b5278586822443594ff615963b0c09755771b3e0"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.26.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[deps.CommonWorldInvalidations]]
git-tree-sha1 = "ae52d1c52048455e85a387fbee9be553ec2b68d0"
uuid = "f70d9fcc-98c5-4d4a-abd7-e4cdeebd8ca8"
version = "1.0.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "f9d7112bfff8a19a3a4ea4e03a8e6a91fe8456bf"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.3"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "66c4c81f259586e8f002eacebc177e1fb06363b0"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.11"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "4820348781ae578893311153d69049a93d05f39d"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.8.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4d81ed14783ec49ce9f2e168208a12ce1815aa25"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+1"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "82d8afa92ecf4b52d78d869f038ebfb881267322"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.3"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "43ba3d3c82c18d88471cfd2924931658838c9d8f"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.0+4"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "1dc470db8b1131cfc7fb4c115de89fe391b9e780"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.12.0"

[[deps.HistogramThresholding]]
deps = ["ImageBase", "LinearAlgebra", "MappedArrays"]
git-tree-sha1 = "7194dfbb2f8d945abdaf68fa9480a965d6661e69"
uuid = "2c695a8d-9458-5d45-9878-1b8a99cf7853"
version = "0.3.1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "8e070b599339d622e9a081d17230d74a5c473293"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.17"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "2e4520d67b0cef90865b3ef727594d2a58e0e1f8"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.11"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageBinarization]]
deps = ["HistogramThresholding", "ImageCore", "LinearAlgebra", "Polynomials", "Reexport", "Statistics"]
git-tree-sha1 = "f5356e7203c4a9954962e3757c08033f2efe578a"
uuid = "cbc4b850-ae4b-5111-9e64-df94c024a13d"
version = "0.3.0"

[[deps.ImageContrastAdjustment]]
deps = ["ImageBase", "ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "eb3d4365a10e3f3ecb3b115e9d12db131d28a386"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.12"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "acf614720ef026d38400b3817614c45882d75500"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.4"

[[deps.ImageCorners]]
deps = ["ImageCore", "ImageFiltering", "PrecompileTools", "StaticArrays", "StatsBase"]
git-tree-sha1 = "24c52de051293745a9bad7d73497708954562b79"
uuid = "89d5987c-236e-4e32-acd0-25bd6bd87b70"
version = "0.1.3"

[[deps.ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "08b0e6354b21ef5dd5e49026028e41831401aca8"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.17"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "PrecompileTools", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "3447781d4c80dbe6d71d239f7cfb1f8049d4c84f"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.6"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "437abb322a41d527c197fa800455f79d414f0a3c"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.8"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils", "Libdl", "Pkg", "Random"]
git-tree-sha1 = "5bc1cb62e0c5f1005868358db0692c994c3a13c6"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.1"

[[deps.ImageMagick_jll]]
deps = ["Artifacts", "Ghostscript_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "OpenJpeg_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "d65554bad8b16d9562050c67e7223abf91eaba2f"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.13+0"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "355e2b974f2e3212a75dfb60519de21361ad3cb7"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.9"

[[deps.ImageMorphology]]
deps = ["DataStructures", "ImageCore", "LinearAlgebra", "LoopVectorization", "OffsetArrays", "Requires", "TiledIteration"]
git-tree-sha1 = "6f0a801136cb9c229aebea0df296cdcd471dbcd1"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.4.5"

[[deps.ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "LazyModules", "OffsetArrays", "PrecompileTools", "Statistics"]
git-tree-sha1 = "783b70725ed326340adf225be4889906c96b8fd1"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.7"

[[deps.ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "44664eea5408828c03e5addb84fa4f916132fc26"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.8.1"

[[deps.ImageShow]]
deps = ["Base64", "ColorSchemes", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "3b5344bcdbdc11ad58f3b1956709b5b9345355de"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.8"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "e0884bdf01bbbb111aea77c348368a86fb4b5ab6"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.10.1"

[[deps.Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageBinarization", "ImageContrastAdjustment", "ImageCore", "ImageCorners", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "12fdd617c7fe25dc4a6cc804d657cc4b2230302b"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.26.1"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0936ba688c6d201805a83da835b55c61a180db52"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.11+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "be8e690c3973443bec584db3346ddc904d4884eb"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "10bd689145d2c3b2a9844005d01087cc1194e79e"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.2.1+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "88a101217d7cb38a7b481ccd50d21876e1d1b0e0"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.15.1"

    [deps.Interpolations.extensions]
    InterpolationsUnitfulExt = "Unitful"

    [deps.Interpolations.weakdeps]
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.IntervalSets]]
git-tree-sha1 = "dba9ddf07f77f60450fe5d2e2beb9854d9a49bd0"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.10"
weakdeps = ["Random", "RecipesBase", "Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "PrecompileTools", "Requires", "TranscodingStreams"]
git-tree-sha1 = "a0746c21bdc986d0dc293efa6b1faee112c37c28"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.53"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "f389674c99bfcde17dc57454011aa44d5a260a40"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.6.0"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "fa6d0bcff8583bac20f1ffa708c3913ca605c611"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.5"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "25ee0be4d43d0269027024d75a24c24d6c6e590c"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.4+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "a9eaadb366f5493a5654e843864c13d8b107548c"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.17"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LittleCMS_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll"]
git-tree-sha1 = "fa7fd067dca76cadd880f1ca937b4f387975a9f5"
uuid = "d3a379c0-f9a3-5b72-a4c0-6bf4d2e8af0f"
version = "2.16.0+0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "a2d09619db4e765091ee5c6ffe8872849de0feea"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.28"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "CloseOpenIntervals", "DocStringExtensions", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "8084c25a250e00ae427a379a5b607e7aed96a2dd"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.171"

    [deps.LoopVectorization.extensions]
    ForwardDiffExt = ["ChainRulesCore", "ForwardDiff"]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.LoopVectorization.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "f046ccd0c6db2832a9f639e2c669c6fe867e5f4f"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "1130dbe1d5276cb656f6e1094ce97466ed700e5a"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "3cebfc94a0754cc329ebc3bab1e6c89621e791ad"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.20"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
git-tree-sha1 = "1a27764e945a152f7ca7efa04de513d473e9542e"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.14.1"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "8292dd5c8a38257111ada2174000a33745b06d4e"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.2.4+0"

[[deps.OpenJpeg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libtiff_jll", "LittleCMS_jll", "libpng_jll"]
git-tree-sha1 = "f4cb457ffac5f5cf695699f82c537073958a6a6c"
uuid = "643b3616-a352-519d-856d-80112ee9badc"
version = "2.5.2+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "67186a2bc9a90f9f85ff3cc8277868961fb57cbd"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.3"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "645bed98cd47f72f67316fd42fc47dee771aefcd"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.2"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "RecipesBase"]
git-tree-sha1 = "3aa2bb4982e575acd7583f01531f241af077b163"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "3.2.13"

    [deps.Polynomials.extensions]
    PolynomialsChainRulesCoreExt = "ChainRulesCore"
    PolynomialsMakieCoreExt = "MakieCore"
    PolynomialsMutableArithmeticsExt = "MutableArithmetics"

    [deps.Polynomials.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    MakieCore = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
    MutableArithmetics = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "8f6bc219586aef8baf0ff9a5fe16ee9c70cb65e4"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.2"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Quaternions]]
deps = ["LinearAlgebra", "Random", "RealDot"]
git-tree-sha1 = "994cc27cdacca10e68feb291673ec3a76aa2fae9"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.7.6"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays"]
git-tree-sha1 = "5680a9276685d392c87407df00d57c9924d9f11e"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.7.1"
weakdeps = ["RecipesBase"]

    [deps.Rotations.extensions]
    RotationsRecipesBaseExt = "RecipesBase"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMD]]
deps = ["PrecompileTools"]
git-tree-sha1 = "98ca7c29edd6fc79cd74c61accb7010a4e7aee33"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.6.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "456f610ca2fbd1c14f5fcf31c6bfadc55e7d66e0"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.43"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays"]
git-tree-sha1 = "4b33e0e081a825dbfaf314decf58fa47e53d6acb"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.4.0"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "2da10356e31327c7096832eb9cd86307a50b1eb6"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "2f5d4697f21388cbe1ff299430dd169ef97d7e14"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.4.0"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.Static]]
deps = ["CommonWorldInvalidations", "IfElse", "PrecompileTools"]
git-tree-sha1 = "87d51a3ee9a4b0d2fe054bdd3fc2436258db2603"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "1.1.1"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "Static"]
git-tree-sha1 = "96381d50f1ce85f2663584c8e886a6ca97e60554"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.8.0"
weakdeps = ["OffsetArrays", "StaticArrays"]

    [deps.StaticArrayInterface.extensions]
    StaticArrayInterfaceOffsetArraysExt = "OffsetArrays"
    StaticArrayInterfaceStaticArraysExt = "StaticArrays"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "eeafab08ae20c62c44c8399ccb9354a04b80db50"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.7"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "5cf7606d6cef84b543b483848d4ae08ad9832b21"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.3"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "eda08f7e9818eb53661b3deb74e3159460dfbc27"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.2"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "SIMD", "UUIDs"]
git-tree-sha1 = "bc7fd5c91041f44636b2c134041f7e5263ce58ae"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.10.0"

[[deps.TiledIteration]]
deps = ["OffsetArrays", "StaticArrayInterface"]
git-tree-sha1 = "1176cc31e867217b06928e2f140c90bd1bc88283"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.5.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "e84b3a11b9bece70d14cce63406bbc79ed3464d2"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "e7f5b81c65eb858bed630fe006837b935518aca5"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.70"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c1a7aa6219628fcd757dede0ca95e245c5cd9511"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.0.0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ac88fb95ae6447c8dda6a5503f3bafd496ae8632"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.6+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "555d1076590a6cc2fdee2ef1469451f872d8b41b"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.6+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "b70c870239dc3d7bc094eb2d6be9b73d27bef280"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.44+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "7dfa0fd9c783d3d0cc43ea1af53d69ba45c447df"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7d0ea0f4895ef2f5cb83645fa689e52cb55cf493"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2021.12.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─d66ffa51-1c09-43c5-86d5-c00ee61609b1
# ╟─466b1feb-e208-4738-be70-733511fb3b6a
# ╟─72ba7e00-8358-11ef-3c2a-73d1b7473118
# ╟─35ce874f-0c25-4ea3-ad96-837a7d262806
# ╟─84284d95-aac1-4816-81db-c61643359868
# ╟─cda23dde-a296-4778-bbff-57667e8151a4
# ╟─4084b55e-1197-43bd-9351-900f228f3474
# ╠═4af0273a-d086-40b2-b7f7-f40540a6a03a
# ╟─75e4a0e5-0864-4cf7-ae57-5ae61c300d89
# ╠═7aff023f-2808-4a0d-8820-f0b6ef754f86
# ╟─855f6dab-3688-48ac-9f50-47bedaf0cc07
# ╟─9fdd0d2e-cb69-4695-be7a-427ae81ea18a
# ╟─37c07894-11c2-49c1-ae1e-81b85b53d431
# ╟─eb9b2a22-1f01-4753-abb5-065a020f6cae
# ╟─dc3a35f3-ceaf-4753-a7d0-999a74fcc028
# ╟─4d8a9765-6c06-4fbd-afae-d8bcbc84707d
# ╟─1c6cddb3-221e-4402-b3a1-c3ad7cb98d55
# ╟─74c31eec-4401-4119-95bd-f8493a9bbd6e
# ╟─7779394e-ac29-4967-9f4b-8b7b7fd7e933
# ╟─14139516-8a6e-441d-bc2c-7e1edb0f6dc5
# ╟─570eb5ad-b330-4d09-83ea-2dc4ea03ac4a
# ╟─448f7c3f-33b1-4a65-86e8-02cc1721a6ee
# ╟─68c24d12-7267-45e3-bb92-09c57560b5df
# ╟─a7270d6a-0df7-4a2f-ac6b-48150d4ad985
# ╟─f854f842-0ba9-4793-b288-f3963a9ba2c4
# ╟─4fc77218-d837-4354-b682-9f7f6840b403
# ╟─c74ab586-6300-4312-9ed8-304ed9d47a36
# ╟─0bb7945a-c7d1-4697-8669-ea7b61ab161e
# ╟─1e9947b9-208e-4a24-ae58-d4084666bab9
# ╟─4bb6aa63-7d4e-4a54-a0ad-6212480aedaf
# ╟─0b0611a5-ee64-48a5-918e-dcb1fcf9392c
# ╟─657b4eb8-ceb0-44b2-a5d4-ab80c7979d7a
# ╟─9273b354-f62f-491c-b555-f76704ddb117
# ╟─219088aa-53e3-4cc0-8e7f-02605890c9c0
# ╟─78790e55-d2dd-4711-9617-203ec5d9f9bf
# ╟─702ced6f-78f8-41ab-b8df-e0c3017f721a
# ╟─1cff311a-3dcb-4460-8060-aa48bcd921ea
# ╟─3ecd61be-b9e6-4e50-b872-7520c4cc737a
# ╟─a96fca5e-3d84-410c-95e5-b85d2c601d00
# ╟─a5c6a0fe-6e0c-467a-b264-1581aee724b2
# ╟─d09d7a36-b427-4e68-b090-f5bee5c46f2f
# ╟─b43d4c6d-34b9-4737-8c82-073d582efe89
# ╟─c96682bc-184a-4060-a2a5-8a0769c0a6ec
# ╟─56cb5413-4dcf-4c38-b870-ce599446351d
# ╟─106e55ee-bc2a-43a6-a845-f352c0c14f03
# ╟─6382a40f-44ca-447d-8f66-dc09c82c4859
# ╟─64795c75-d73d-4783-a6db-a27ce7c508f4
# ╟─4fa90df6-10e3-4373-85be-37b58f6161b3
# ╟─ccb8c00e-4d76-4f61-b91b-96c38acf57cc
# ╟─62c61a0f-24b2-4e18-bd48-33aa7da86de6
# ╟─33f711d8-6adb-46e9-b62f-f1ac91bf7a18
# ╟─dd939590-aa6d-44a2-adc3-206456e53d82
# ╟─4a9cb1f5-1e23-4550-9957-6cb8c0cb6c44
# ╟─311617f9-20ca-455f-b5a7-ff48f991c25c
# ╟─dfe69cfe-447c-41a5-b13e-af9a4aaf5705
# ╟─efa810db-cc21-401d-9ca8-f8ccf7c16a60
# ╟─0ad51475-558d-4afa-acee-cf0ee2b1ac89
# ╟─e8f07802-39e7-4a60-b7df-d5310cd6f193
# ╟─59558c2f-aac4-447c-be7c-ce64e900bf2d
# ╟─d9cbe652-6298-4030-82ea-9575f505edcb
# ╟─3108597f-a618-42e8-bd66-d03e5ca472dc
# ╟─c874b86b-a4c2-4d94-a6ce-52bcc2eb804a
# ╟─1b3a5265-0764-4916-802c-0b8b6eeb846a
# ╟─c7080e3a-4105-4e00-afa5-b3d7e21363b5
# ╟─0e1148e0-3182-48e9-ad29-9488cb9fa178
# ╟─c00abd35-6214-46c3-bc89-040fd51a60fb
# ╟─2ae5564e-ed04-4427-8e98-716aa30ffef5
# ╟─e8ba6a27-1af9-484e-b2e2-4757b929ebf4
# ╟─fd44eb04-9b42-4f96-abd0-a4cd9c885938
# ╟─a125d641-ea48-4b02-9251-90b93e65ff92
# ╟─8ad95a68-ea3a-4382-897c-683548faed66
# ╟─1ab467bf-950e-43ab-92cb-eea0f57b3611
# ╟─a131d94c-d87c-461d-8b35-6c36272471ef
# ╟─d0f59290-7de4-4dd5-9add-7901605eafed
# ╟─3219563c-80c1-4172-9fbf-9ab09cdfd552
# ╟─a9530888-3461-44e3-9e26-b92d297d2e6d
# ╟─543c9b4a-65b3-4776-8160-709b0eafbb30
# ╟─d372541c-5c51-471d-b219-ca25e6672afb
# ╟─18b8c4f1-1a1c-44f3-960b-0868a6b6e719
# ╟─ff0abfd7-50e3-49f7-b88f-db927c5474dd
# ╟─0b57d5ec-2a0b-4125-97ae-93d059c8f7d7
# ╟─c7e204ef-2772-4a68-a23c-43f19ceea55c
# ╟─9e37bdad-3373-4019-8dee-44afc17f64c9
# ╟─546366c7-0852-4a52-aa7e-92bc2a9dcfaa
# ╟─899f8966-5f06-4555-94c5-abf9f23428b2
# ╟─56bda6d6-93f4-4e78-a18d-d3040739f042
# ╟─e0c3dbbd-53ee-4289-94d7-3f14c39ea581
# ╟─53115341-43bc-4228-8912-b2d8a4327e0c
# ╟─4eafeb10-cd76-4322-b823-e9d9a4a0661a
# ╟─8415dbb7-00e4-432b-8dc3-635a02b18ef5
# ╟─655b625c-880a-452c-a2e9-162ea99f11b3
# ╟─69dbea1c-5279-4817-8e7e-f4fd15772e9a
# ╟─fda066f9-d038-4e53-9a38-6ebc615277f2
# ╟─e2b548b2-e90f-4b0e-b729-580014fce745
# ╟─f64ec907-75bc-4e74-8ee0-4bf40de49f14
# ╟─29a4425e-8130-40d2-b569-cd855ecc00cb
# ╟─ba29022f-f125-479e-9de2-b59b89b0c800
# ╟─f33dcd95-ce27-4198-902f-0e175cd9bde6
# ╟─e1d1b176-fc0d-4630-9ca0-3b5952065940
# ╟─26e5118e-9204-49bc-9a56-cc0c514a94f9
# ╟─ff7b65c2-07e7-4718-be79-d0220f542e0e
# ╟─d2c9d8d6-18a2-4f61-9a44-49957fd04079
# ╟─86ef17db-c061-4466-becb-ae24236e1efb
# ╟─59bd251a-f431-4a97-8ba9-da0741826c11
# ╟─76d84762-be6e-42a9-b4ee-7314f7060b7d
# ╟─d90671f6-3f93-4892-8f7a-eaab0fbc8805
# ╟─19917921-41a1-44da-bc7a-6973104512ab
# ╟─2db8d6e2-14cf-4d44-beea-d6eeb31c2824
# ╟─d5894183-2f0b-4abb-84b4-fe0a01474040
# ╟─732f3808-da57-4901-a820-774e97643c89
# ╟─a370295e-f607-4cff-87d3-aabfa86a8481
# ╟─2934bfe2-f99b-444e-a515-1e0e3c564550
# ╟─de73d800-42a9-453f-8f41-b0e5e41e33b5
# ╟─9ac6ecfd-6cff-4adc-958b-e97c2400e442
# ╟─790b47eb-d36c-4813-97b4-69b4fc2245c6
# ╟─d7324566-04b6-41fc-b89b-b8a271c803d2
# ╟─9e9cee08-abc2-416b-9214-65553af01d0e
# ╟─f5f83673-d736-4ee5-aba8-94955b20912d
# ╟─09f4e91e-3878-43ac-a999-98411f725b98
# ╟─d4746780-e553-44b2-847a-630683218793
# ╟─eeab4c33-e2cb-4b0f-94f2-f61df40431ff
# ╟─29392f88-3642-4e0d-8f10-722050b0d592
# ╟─baaab24a-b613-4847-bccf-19ecde9053be
# ╟─4936a275-61ef-45ea-aa89-a7883bbcb654
# ╟─084c0f6d-2b99-4e3d-b456-92169ad0ebc7
# ╟─bd379906-d836-4ee5-beed-b730eb329551
# ╟─cf17b927-06a7-4dae-95d8-e67f2d72301b
# ╟─c7bcd465-bea8-488f-924d-c6803e24eb87
# ╟─2b29e638-26bb-424b-aff1-ca83c56dd6b3
# ╟─e93d15de-05eb-4fb6-b787-162ec7b8c162
# ╟─5761d3d6-6ef7-451b-b436-fa04068ad80a
# ╟─55788670-051e-45f2-95c4-a739a7aa577d
# ╟─f26f6782-a79a-4a94-9836-cee4142a35f2
# ╟─2705658f-3726-45c3-80b9-8de4612b3cbe
# ╟─3b035209-d2b3-468e-99f0-8394567bbaa4
# ╟─634ea18b-5627-457c-9d8e-c998df8b174b
# ╟─71649cb3-0552-4f57-b0c2-bcdd55f38767
# ╟─eb5c6985-0558-4306-91ce-00cd88bca949
# ╟─f2167acb-a994-4c66-b7fc-923cd5eec91b
# ╟─27485f3f-eeb8-49f1-b0ea-7ad5b755ff54
# ╟─967d9492-faa1-4974-9883-a061e684a5cb
# ╟─615977de-eaae-49cd-aafa-4636cc3d9c42
# ╟─02462594-d026-4057-9e90-daf95bd8da06
# ╟─54f252f7-d6bd-4f41-a940-8c7cac1589ff
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002

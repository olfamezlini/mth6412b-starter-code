module STSP

using Random, FileIO, Images, ImageView, ImageMagick, Dates

using Plots

import Base.show, Base.length, Base.push!, Base.popfirst!, Base.maximum

include("phase5/node.jl")
include("phase5/affichage_kruskal.jl")
include("phase5/affichage_prim.jl")
include("phase5/composantes_connexe.jl")
include("phase5/edge.jl")
include("phase5/graph.jl")
include("phase5/HK.jl")
include("phase5/kruskal.jl")
include("phase5/prim.jl")
include("phase5/priority_queue.jl")
include("phase5/read_stsp.jl")
include("phase5/RSL.jl")
include("phase5/instances_weights.jl")
include("phase5/affichage_RSL.jl")
include("phase5/affichage_HK.jl")
include("phase5/recherche_param_opt.jl")
include("phase5/affichage_resultats.jl")
include("phase5/tools.jl")
include("phase5/images_dechiquetees.jl")

end # module STSP
module STSP

using Plots

import Base.show, Base.length, Base.push!, Base.popfirst!, Base.maximum

include("phase4/node.jl")
include("phase4/affichage_kruskal.jl")
include("phase4/affichage_prim.jl")
include("phase4/composantes_connexe.jl")
include("phase4/edge.jl")
include("phase4/graph.jl")
include("phase4/kruskal.jl")
include("phase4/prim.jl")
include("phase4/priority_queue.jl")
include("phase4/read_stsp.jl")
include("phase4/RSL.jl")
include("phase4/instances_weights.jl")
include("affichage_RSL")

end # module STSP
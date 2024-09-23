import Base.show
include("edge.jl")
include("node.jl")
A=Node("A",3)
B=Node("B",3)
AB=Edge("AB",3,A,B)
show(A)

show(AB)
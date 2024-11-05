using STSP, Test

@testset "fake tests" begin
  @test 1==1

  @test true * false != true * true

  @test Bool(true + false) == true
  
end

noeud = Node("Lars", 2)
@test noeud.name=="Lars"
@test noeud.data==2
@testset "Relation between STD-COR-RMSD" begin
    Cr = rand(10)*10 
    C  = Cr + rand(10)
    @test isapprox(taylor_verification(Cr,C), 0.0; atol=1e-13, rtol=0)
end;

#@testset "Plotting with S,R,C" begin
#    Cr = rand(10)*10 
#    C  = Cr + rand(10)
#    S  = [STD(Cr), STD(C)]
#    C  = [COR(Cr,Cr), COR(Cr,C)]
#    @test taylordiagram(S,R,C)
#end;



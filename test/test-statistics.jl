@testset "Standard deviation" begin
    C1 = [1.0, 1.0, 1.0]
    C2 = [1.0, 0.0, 0.0, 1.0]
    @test STD(C1) == 0.
    @test STD(C2) == 0.5
end;

@testset "Mean" begin
    C1 = [1.0, 1.0, 1.0]
    C2 = [1.0, 0.0, 0.0, 1.0]
    @test TaylorDiag.mean(C1) == 1.0
    @test TaylorDiag.mean(C2) == 0.5
end;

@testset "RMSD" begin
    Cr = [1.0, 1.0, 1.0]
    C1 = [1.0, 1.0, 1.0]
    C2 = [0.0, 0.0, 0.0]
    C3 = [1.0, 2.0, 3.0]
    @test RMSD(Cr,C1) == 0.
    @test RMSD(Cr,C2) == 0.
    @test RMSD(Cr,C3) == 0.816496580927726
end;

@testset "Correlation coefficient" begin
    Cr = [1.0, 2.0, 3.0]
    C1 = [1.0, 1.0, 1.0]
    C2 = [0.0, 0.0, 0.0]
    C3 = [1.0, 2.0, 3.0]
    CrRand = rand(10) 
    C1Rand = CrRand * 104.4
    C2Rand = CrRand * 104.4 .+ 154.
    C3Rand = CrRand * 104.4 .+ 154.0*rand(10)
    @test isnan(COR(Cr,C1))
    @test isnan(COR(Cr,C2))
    @test COR(Cr,C3) == 1.0
    @test COR(CrRand,C1Rand) == 1.0
    @test COR(CrRand,C2Rand) == 1.0
    @test COR(CrRand,C3Rand) != 1.0
end;
using TaylorDiag
using Test
using Random

@testset "Statistics" begin
    include("test-statistics.jl")
end

@testset "Plotting" begin
    include("test-plotting.jl")
end
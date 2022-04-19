using Test
using PaddedMatrix

@testset "Creation" begin
    m = [1 2; 3 4]
    p = Padded(m, fill_with=0)
    @test size(p.m) == (4, 4)
    @test typeof(p) == Padded{Int}
end

@testset "Padding Width" begin
    m = [1 2; 3 4]
    p = Padded(m, fill_with=0, padding_size=3)
    @test size(p.m) == (8, 8)
end

using Test
using PaddedMatrix

@testset "Creation" begin
    m = [1 2; 3 4]
    p = Padded(m, fill_with=0)
    @test size(p.m) == (4, 4)
    @test typeof(p) == Padded{Int}
end

@testset "Creation from Vector" begin
    v = [1, 2, 3]
    p = Padded(v, fill_with=0)
    @test size(p.m) == (3, 5)
end

@testset "Padding Width" begin
    m = [1 2; 3 4]
    p = Padded(m; fill_with=0, padding_size=3)
    @test size(p.m) == (8, 8)
end

@testset "Core Positions" begin
    m = [1 2; 3 4]
    p = Padded(m; fill_with=0, padding_size=3)
    new = map(core_indicees(p)) do (i, j)
        p.m[i, j]
    end
    @test m == new
end
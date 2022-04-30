module PaddedMatrix

import Base.show
"""
A Matrix, with one padding frame, with *fill_with* value

```jldoctest
core = [1 2; 3 4]
padded = Padded(mcore, 0)
padded.m

4×4 Matrix{Int64}:
 0  0  0  0
 0  1  2  0
 0  3  4  0
 0  0  0  0

```
"""
struct Padded{T}
    m::Matrix{T}
    padding::Int
    function Padded(v::Vector{T}; fill_with::T, padding_size::Integer=1) where {T}
        if padding_size < 1
            throw("Cannot create PaddedMatrix with padding smaller than 1!")
        end
        (rows, cols) = (1, length(v))
        default_cols = map(e -> fill_with, 1:cols+2*padding_size) |> transpose
        default_rows = [fill_with]

        padded = v'
        for _ in 1:padding_size
            padded = hcat(default_rows, padded, default_rows)
        end
        for _ in 1:padding_size
            padded = vcat(default_cols, padded, default_cols)
        end

        new{T}(padded, padding_size)
    end

    function Padded(m::Matrix{T}; fill_with::T, padding_size::Integer=1) where {T}
        if padding_size < 1
            throw("Cannot create PaddedMatrix with padding smaller than 1!")
        end
        (rows, cols) = size(m)

        default_cols = map(e -> fill_with, 1:cols+2*padding_size) |> transpose
        default_rows = map(e -> fill_with, 1:rows)

        padded = m
        for _ in 1:padding_size
            padded = hcat(default_rows, padded, default_rows)
        end
        for _ in 1:padding_size
            padded = vcat(default_cols, padded, default_cols)
        end

        new{T}(padded, padding_size)
    end
end


"""
Yield the unpadded core indicees from a Padded Matrix
```julia-repl
m = [1 2; 3 4]
p = Padded(m; fill_with=0, padding_size=3)
new = map(p.m[i, j],core_indicees(p))
new == m
```
"""
function core_indicees(m::Padded{T}) where {T}
    (rows, columns) = size(m.m)
    return ((i, j) for i in 1+m.padding:rows-m.padding, j in 1+m.padding:columns-m.padding)
end

function Base.show(io::IO, m::Padded)
    (rows, cols) = size(m.m)
    print(io,
        ("PaddedMatrix with core size $(rows - 2)x$(cols - 2)\n" *
         "Padding width $(m.padding) and filled with $(m.m[1,1])\n" *
         "Content: "))
    Base.show(stdout, "text/plain", m.m)
end

export Padded, core_indicees
end # module

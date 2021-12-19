using CellListMap
using StaticArrays
using LinearAlgebra
using PyCall
using DelimitedFiles


function _count_pairs!(i, j, weights1, weights2, counts)
    counts[i] += weights1[i] * weights2[j]
    return counts
end 

function count_pairs_survey(
    positions1, positions2, weights1, weights2, rmax
)
    positions1 = convert(Array{Float64}, positions1)
    positions2 = convert(Array{Float64}, positions2)
    weights1 = convert(Array{Float64}, weights1)
    weights2 = convert(Array{Float64}, weights2)
    npos1 = size(positions1)[1]
    D1D2 = zeros(Int, npos1);
    
    box = Box(limits(positions1, positions2), rmax)

    cl = CellList(positions1, positions2, box)

    D1D2 = map_pairwise!(
        (x, y, i, j, d2, output) ->
        _count_pairs!(i, j, weights1, weights2, D1D2),
        D1D2, box, cl,
        parallel=true
    )

    return D1D2

end

function count_pairs_box(
    positions1, positions2, weights1, weights2, box_size, rmax
)
    positions1 = convert(Array{Float64}, positions1)
    positions2 = convert(Array{Float64}, positions2)
    weights1 = convert(Array{Float64}, weights1)
    weights2 = convert(Array{Float64}, weights2)
    npos1 = size(positions1)[1]
    D1D2 = zeros(Int, npos1);
    
    Lbox = [box_size, box_size, box_size]
    box = Box(Lbox, rmax)

    cl = CellList(positions1, positions2, box)

    D1D2 = map_pairwise!(
        (x, y, i, j, d2, output) ->
        _count_pairs!(i, j, weights1, weights2, D1D2),
        D1D2, box, cl,
        parallel=true
    )

    return D1D2

end

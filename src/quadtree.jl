"""Generate quadtree root from .lax header."""
function quadtree(header::LaxQuadtreeHeader)
    root = Cell(SVector(header.min_x, header.min_y), SVector(header.max_x - header.min_x, header.max_y - header.min_y), Vector{UnitRange{Integer}}())
end

"""Add data to a quadtree cell with given index."""
function quadtree!(root::RegionTrees.Cell, index::Integer, data::Vector{UnitRange{T}}) where T <: Integer
    cell = quadtree!(root, index)
    cell.data = data
    return cell
end

"""Split a quadtree until the requested index is reached."""
function quadtree!(root::RegionTrees.Cell, index::Integer)
    places = zlevels(index)
    places = reverse(places, dims=1)  # bottom up

    for place in places
        (place != 0) && (isleaf(root)) && (split!(root))
        root = getindex(root, place)
    end
    return root
end

"""For a given Quadtree index, return one of [1,2,3,4] for each level in the quadtree.
Levels are defined as follows, where the index is the number. 
0
1 2 3 4
5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
21 - 84 etc
"""
function zlevels(index::Integer)
    places = Array{Integer,1}()
    
    # Determine places until root is reached
    while index > 4

        # index one level up in the quadtree
        parent_cell = (index - 1) >>> 2

        # place is position in Z order of four cells
        place = index - (parent_cell << 2)

        push!(places, place)
        index = parent_cell
    end

    push!(places, index)
    return places
end

"""Convert place in Z order to RegionTrees index."""
function Base.getindex(cell::Cell, place::Integer)
    # 3 4
    # 1 2
    place == 4 && return cell[2,2]
    place == 3 && return cell[1,2]
    place == 2 && return cell[2,1]
    place == 1 && return cell[1,1]
    place == 0 && return cell  # root cell
    error("Place can't be higher than 4.")
end

using StaticArrays

function quadtree(header::LaxQuadtreeHeader)
    root = Cell(SVector(header.min_x, header.min_y), SVector(header.max_x, header.max_y), Vector{CartesianRange}())
end

function quadtree!(root::RegionTrees.Cell, index::Int32, data::Vector{CartesianRange})
    for i in data
        @show i, index
    end
    cell = descend(root, index)
    cell.data = data
    return cell
end

function descend(root::RegionTrees.Cell, index::Int32)
    places = Array{Int32,1}()
    @show index
    while index > 4
        @show index
        upper_index = (index - 1) >> 2
        place = index - (upper_index << 2)
        push!(places, place)
        index = upper_index
    end
    push!(places, index)
    @show places

    flipdim(places, 1)  # reverse places


    for place in places
        if isleaf(root)
            split!(root)
        end
        root = placeindex(root, place)
    end
    return root
end

"""Convert place in Z order to RegionTrees index."""
function placeindex(cell::Cell, place::Int32)
    if place == 4 return cell[2,2] end
    if place == 3 return cell[1,2] end
    if place == 2 return cell[2,1] end
    if place == 1 return cell[1,1] end
end

using StaticArrays

function quadtree(header::LaxQuadtreeHeader)
    root = Cell(SVector(header.min_x, header.min_y), SVector(header.max_x, header.max_y), Vector{LaxIntervalCellInterval}(0))
end

function quadtree!(root::RegionTrees.Cell, index::Int32, data::Vector{LaxIntervalCellInterval})
    for i in data
        @show i.start i._end
    end
    # cell = descend(root, index)
    # cell.data = data
    # return cell
end

# function descend(root:cell, index::UInt32)
#     while index != 0
#         isleaf(cell) && split!(root)

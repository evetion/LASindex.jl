"""
Intersect quadtree with bounding box, returning all merged data in cells.
bbox format is bb_xmin, bb_xmax, bb_ymin, bb_ymax.
"""
function intersect(qt::RegionTrees.Cell{Array{UnitRange{Integer},1},2,Float64,4}, bbox::SVector{4, Float64})
    # Explode for readability
    o = qt.boundary.origin
    w = qt.boundary.widths
    qt_xmin, qt_xmax, qt_ymin, qt_ymax = o[1], o[1] + w[1], o[2], o[2] + w[2]
    bb_xmin, bb_xmax, bb_ymin, bb_ymax = bbox

    # Bounding boxes completely separate => nothing
    if ((qt_xmin > bb_xmax) || (qt_xmax < bb_xmin) || (qt_ymin > bb_ymax) || (qt_ymax < bb_ymin))
        return Vector{UnitRange{Integer}}()

    # Otherwise some intersection:
    # Some (whole or partial) intersection without children => everything
    elseif isleaf(qt)
        return merge(qt.data)

    # With children
    # if completely covered => everything from children
    elseif ((qt_xmin > bb_xmin) && (qt_xmax < bb_xmax) && (qt_ymin > bb_ymin) && (qt_ymax < bb_ymax))
        return merge(vcat([leaf.data for leaf in allleaves(qt) if length(leaf.data) > 0]...))
    # otherwise => check intersect for children
    else
        return merge(vcat([intersect(c, bbox) for c in children(qt)]...))
    end
end

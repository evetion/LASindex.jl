module LASindex

    using FileIO
    using RegionTrees
    using StaticArrays

    export
    quadtree

    include("fileio.jl")
    include("quadtree.jl")
    include("spatial.jl")
    include("util.jl")

    function __init__()
      add_format(format"LAX", "LASX", ".lax", [:LASindex])
    end

end # module

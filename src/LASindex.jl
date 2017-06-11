__precompile__()

module LASindex

    using FileIO
    using RegionTrees

    export
    quadtree

    include("fileio.jl")
    include("quadtree.jl")
    include("util.jl")

    function __init__()
      add_format(format"LAX", "LASX", ".lax", [:LASindex])
    end

end # module

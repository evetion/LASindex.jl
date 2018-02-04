[![Build Status](https://travis-ci.org/evetion/LASindex.jl.svg?branch=master)](https://travis-ci.org/evetion/LASindex.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/llopduxmvf6obgu4?svg=true)](https://ci.appveyor.com/project/evetion/lasindex-jl)
[![codecov](https://codecov.io/gh/evetion/LASindex.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/evetion/LASindex.jl)

# LASindex.jl
Pure Julia reader of lasindex .lax files. 
Translates the .lax file to a quadtree from the RegionTrees package and provides a bounding box intersect method to retrieve a vector of ranges.

```julia

julia> using LASindex
julia> using FileIO

julia> laxfile = joinpath("sample", "Palm Beach Post Hurricane.lax");
julia> qt = load(laxfile)
INFO: Processed Palm Beach Post Hurricane.lax with 1924631 points.
Cell: RegionTrees.HyperRectangle{2,Float64}([955000.0, 885000.0], [32000.0, 32000.0])

julia> using StaticArrays
julia> bbox = SVector(955000.0, 985002.0, 885000.0, 988800.0);
julia> r = LASindex.intersect(qt, bbox)
1-element Array{UnitRange{Integer},1}:
 1:1924631

```

The resulting ranges can be used in combination with LasIO or LazIO to stream a small subset of a (larger than memory) dataset.

```julia
using LasIO
header, points = load("Palm Beach Post Hurricane.las", mmap=true)

intersected_points = points[LASindex.intersect(qt, bbox)]
```

Note that all points inside the bounding box are given, but not all points given are inside the bounding box. In other words, because of how `lasindex` groups ranges together, some ranges will include points outside the bounding box.

### Background
LAX files are quadtree indexes used by the LASTools suite [1] if present. You can generate them with `lasindex -i *.laz`[2]. There's a good introduction to lasindex here [3]. 

- [1] https://rapidlasso.com/lastools/
- [2] https://github.com/LAStools/LAStools/blob/master/bin/lasindex_README.txt
- [3] https://www.youtube.com/watch?v=FMcBywhPgdg

### Future
I'd rather use Cxx to call the lasindex c++ code directly,
but at the moment the Cxx package is harder to install on Windows
than compiling the lastools shared library itself.

An example how to interface with lastools directly is provided in example/cxx.jl

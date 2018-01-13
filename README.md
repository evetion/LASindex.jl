[![Build Status](https://travis-ci.org/evetion/LASindex.jl.svg?branch=master)](https://travis-ci.org/evetion/LASindex.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/llopduxmvf6obgu4?svg=true)](https://ci.appveyor.com/project/evetion/lasindex-jl)
[![codecov](https://codecov.io/gh/evetion/LASindex.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/evetion/LASindex.jl)

# LASindex.jl
Pure Julia reader of lasindex .lax files. 
Translates the .lax file to a quadtree from the RegionTrees package.

```julia

using LASindex
using FileIO

laxfile = joinpath("sample", "Palm Beach Post Hurricane.lax")
qt = load(laxfile)

```


### Background
LAX files are quadtree indexes used by the LASTools suite [1] if present. You can generate them with `lasindex -i *.laz`[2]. There's a good introduction to lasindex here [3]. 

[1] https://rapidlasso.com/lastools/

[2] https://github.com/LAStools/LAStools/blob/master/bin/lasindex_README.txt

[3] https://www.youtube.com/watch?v=FMcBywhPgdg


### Future
I'd rather use Cxx to call the lasindex c++ code directly,
but at the moment the Cxx package is harder to install on Windows
than compiling the lastools shared library itself.

An example how to interface with lastools directly is provided in example/cxx.jl

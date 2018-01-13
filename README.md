# LASindex.jl
Pure Julia reader of lasindex .lax files. 
Translates the .lax file to a quadtree from the RegionTrees package.
Extends RegionTrees with a spatial intersection (only boundingbox).

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

# LASindex.jl
Pure Julia reader of lasindex .lax files

Translates the .lax file to a quadtree from the RegionTrees package.
Extends RegionTrees with a spatial intersection (only boundingbox).

## Future
I'd rather use Cxx to call the lasindex c++ code directly,
but at the moment the Cxx package is harder to install on Windows
than compiling the lastools shared library itself.

An example how to interface with lastools directly is provided in example/cxx.jl

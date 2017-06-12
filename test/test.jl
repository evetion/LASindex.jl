workdir = dirname(@__FILE__)
# include(joinpath(workdir, "..", "src/LASindex.jl")

using LASindex
using FileIO
using Plots

# source: http://www.liblas.org/samples/ and lasindex
index = joinpath(workdir, "..", "sample", "Palm Beach Post Hurricane.lax")

qt = load(index)

for leaf in RegionTrees.allleaves(qt)
    @show leaf.data
end

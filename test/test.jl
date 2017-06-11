workdir = dirname(@__FILE__)
include(joinpath(workdir, "..", "src/LASindex.jl")

using LASindex

# source: http://www.liblas.org/samples/ and lasindex
index = joinpath(workdir, "..", "sample", "Palm Beach Post Hurricane.lax")

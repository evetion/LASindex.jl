using LASindex
using FileIO
using RegionTrees
using StaticArrays
using Test

workdir = dirname(@__FILE__)

# source: http://www.liblas.org/samples/ and lasindex
index = joinpath(workdir, "..", "sample", "Palm Beach Post Hurricane.lax")

# Header check
qt = load(index)

# Determine correct quadtree levels
@test LASindex.zlevels(0) == [0]
@test LASindex.zlevels(1) == [1]
@test LASindex.zlevels(4) == [4]
@test LASindex.zlevels(5) == [1,1]
@test LASindex.zlevels(20) == [4,4]
@test LASindex.zlevels(21) == [1,1,1]
@test LASindex.zlevels(22) == [2,1,1]
@test LASindex.zlevels(84) == [4,4,4]
@test LASindex.zlevels(85) == [1,1,1,1]

# Single integer indexing on RegionTrees cells
# based on Z order
root = Cell(SVector(0., 0), SVector(1., 1))
split!(root)
@test root[1] == root[1,1]
@test root[2] == root[2,1]
@test root[3] == root[1,2]
@test root[4] == root[2,2]
@test root[0] == root
@test_throws ErrorException root[5]

# Split cell based on given index level
# until cell with index is found, return it
root = Cell(SVector(0., 0), SVector(1., 1))
@test LASindex.quadtree!(root, 1).boundary.origin ≈ Cell(SVector(0., 0), SVector(0.5, 0.5)).boundary.origin
@test LASindex.quadtree!(root, 4).boundary.origin ≈ Cell(SVector(0.5, 0.5), SVector(0.5, 0.5)).boundary.origin
@test LASindex.quadtree!(root, 5).boundary.origin ≈ Cell(SVector(0., 0), SVector(0.25, 0.25)).boundary.origin
@test LASindex.quadtree!(root, 20).boundary.origin ≈ Cell(SVector(0.75, 0.75), SVector(0.25, 0.25)).boundary.origin
@test LASindex.quadtree!(root, 1).boundary.widths ≈ Cell(SVector(0., 0), SVector(0.5, 0.5)).boundary.widths
@test LASindex.quadtree!(root, 4).boundary.widths ≈ Cell(SVector(0.5, 0.5), SVector(0.5, 0.5)).boundary.widths
@test LASindex.quadtree!(root, 5).boundary.widths ≈ Cell(SVector(0., 0), SVector(0.25, 0.25)).boundary.widths
@test LASindex.quadtree!(root, 20).boundary.widths ≈ Cell(SVector(0.75, 0.75), SVector(0.25, 0.25)).boundary.widths

# Adding data to quadtree cell based on index
root = Cell(SVector(0., 0), SVector(1., 1), Vector{UnitRange{Int}}())
LASindex.quadtree!(root, 1, [2:5])
@test root[1,1].data == [2:5]

# Merge UnitRanges that do have overlap
r = Vector{UnitRange{Integer}}([1:5, 2:4, 12:13, 14:16])
@test LASindex.merge(r) == Vector{UnitRange{Integer}}([1:5, 12:16])
# and again to make sure it's not mutating
@test LASindex.merge(r) == Vector{UnitRange{Integer}}([1:5, 12:16])
r = Vector{UnitRange{Integer}}([1:5, 2:6, 12:13, 14:16, -1:2])
@test LASindex.merge(r) == Vector{UnitRange{Integer}}([-1:6, 12:16])
r = Vector{UnitRange{Integer}}()
@test LASindex.merge(r) == Vector{UnitRange{Integer}}()
r = Vector{UnitRange{Integer}}([1:5])
@test LASindex.merge(r) == Vector{UnitRange{Integer}}([1:5])

# Test spatial intersection
bbox = SVector(955000.0, 955002.0, 885000.0, 988800.0)  # small intersection
@test LASindex.intersect(qt, bbox) == Vector{UnitRange{Integer}}()
bbox = SVector(955000.0, 985002.0, 885000.0, 988800.0)  # fully overlaps
@test LASindex.intersect(qt, bbox) == Vector{UnitRange{Integer}}([1:1924631])

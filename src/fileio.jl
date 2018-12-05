using FileIO

struct LaxHeader
    version::UInt32
end

function Base.read(io::IO, ::Type{LaxHeader})
    header = LaxHeader(
        read(io, UInt32),
        )
end

struct LaxQuadtreeHeader
    ssignature::UInt32  # LASS
    stype::UInt32
    qsignature::UInt32  # LASQ
    version::UInt32
    levels::UInt32
    level_index::UInt32
    implicit_levels::UInt32
    min_x::Float64
    max_x::Float64
    min_y::Float64
    max_y::Float64
end


function Base.read(io::IO, ::Type{LaxQuadtreeHeader})
    header = LaxQuadtreeHeader(
        read(io, UInt32),
        read(io, UInt32),
        read(io, UInt32),
        read(io, UInt32),
        read(io, UInt32),
        read(io, UInt32),
        read(io, UInt32),
        Float64(read(io, Float32)),
        Float64(read(io, Float32)),
        Float64(read(io, Float32)),
        Float64(read(io, Float32))
    )
end

struct LaxIntervalHeader
    signature::UInt32
    version::UInt32
    number_cells::UInt32
end

function Base.read(io::IO, ::Type{LaxIntervalHeader})
    header = LaxIntervalHeader(
        read(io, UInt32),
        read(io, UInt32),
        read(io, UInt32),
    )
end

struct LaxIntervalCell
    cell_index::Int32
    number_intervals::UInt32
    number_points::UInt32
end

function Base.read(io::IO, ::Type{LaxIntervalCell})
    header = LaxIntervalCell(
        read(io, UInt32),
        read(io, UInt32),
        read(io, UInt32)
    )
end

struct LaxIntervalCellInterval
    _start::UInt32
    _end::UInt32
end

function Base.read(io::IO, ::Type{UnitRange{T}}) where T <: Integer
    range = UnitRange(
        Int64(read(io, UInt32))+1,  # .lax uses 0 based indices
        Int64(read(io, UInt32))+1   # Int32 could theoretically overflow
    )
end

function load(f::File{format"LAX"})
    open(f) do s
        skipmagic(s)
        load(s)
    end
end

function load(s::Stream{format"LAX"})
    # magic bytes are skipped
    header = read(s, LaxHeader)

    # read quadtree
    qheader = read(s, LaxQuadtreeHeader)
    # if not, qsignature and version are missing
    # but we ignore this other lax type for now
    qheader.level_index != 0 && error("Level index other than 0 is not supported yet.")

    # create quadtree
    qt = quadtree(qheader)

    # read cell header
    iheader = read(s, LaxIntervalHeader)
    ncells = iheader.number_cells

    # total number of points
    total_points = 0

    for i = 1:ncells
        # Read cell and its intervals
        qcell = read(s, LaxIntervalCell)
        total_points += qcell.number_points
        intervals = Vector{UnitRange{Integer}}(undef, qcell.number_intervals)

        for j = 1:qcell.number_intervals
            intervals[j] = read(s, UnitRange{Integer})
        end

        # Create cell in qt with intervals
        quadtree!(qt, qcell.cell_index, intervals)

    end

    # assert we are at end of file
    @assert eof(s)

    @info("Processed $(s.filename) with $(total_points) points.")

    return qt
end

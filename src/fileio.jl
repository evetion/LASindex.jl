
type LaxHeader
    version::UInt32
end

function Base.read(io::IO, ::Type{LaxHeader})
    header = LaxHeader(
        read(io, UInt32),
        )
end

type LaxQuadtreeHeader
    ssignature::UInt32  # LASS
    stype::UInt32  #
    qsignature::UInt32  # LASQ
    version::UInt32
    levels::UInt32
    level_index::UInt32
    implicit_levels::UInt32
    min_x::Float32
    max_x::Float32
    min_y::Float32
    max_y::Float32
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
        read(io, Float32),
        read(io, Float32),
        read(io, Float32),
        read(io, Float32)
    )
end

type LaxIntervalHeader
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

type LaxIntervalCell
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

type LaxIntervalCellInterval
    start::UInt32
    _end::UInt32  # reserved
end

function Base.read(io::IO, ::Type{LaxIntervalCellInterval})
    header = LaxIntervalCellInterval(
        read(io, UInt32),
        read(io, UInt32)
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
    @show qheader.qsignature

    # create quadtree
    qt = quadtree(qheader)
    @show qt

    # read cell header
    iheader = read(s, LaxIntervalHeader)
    ncells = iheader.number_cells

    for i = 1:ncells
        # Read cell and its intervals
        cell = read(s, LaxIntervalCell)
        intervals = Vector{LaxIntervalCellInterval}(cell.number_intervals)
        for j = 1:cell.number_intervals
            intervals[j] = read(s, LaxIntervalCellInterval)
        end

        # Create cell in qt with intervals
        quadtree!(qt, cell.cell_index, intervals)

    end

    # assert we are at end of file
    @assert eof(s)
end

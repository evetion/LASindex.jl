"""Merge vector of UnitRanges into Vector of UnitRanges that do not overlap."""
function merge(ranges::Vector{UnitRange{Integer}})
    # prevent unwanted mutation
    ranges = copy(ranges)

    # Skip if there's nothing to merge
    length(ranges) <= 1 && (return ranges)

    merged_ranges = Vector{UnitRange{Integer}}()

    # smallest start at the end
    sort!(ranges, by=x->(x.start, x.stop), rev=true)
    while length(ranges) > 1
        r1 = pop!(ranges)

        # Overlap checking
        overlaps = r1.stop >= ranges[end].start - 1
        exceeds = r1.stop > ranges[end].stop

        # No overlap => push to merged_ranges
        if !overlaps
            push!(merged_ranges, r1)
        elseif exceeds
            ranges[end] = r1.start:r1.stop
        else
            ranges[end] = r1.start:ranges[end].stop
        end
    end
    push!(merged_ranges, ranges[end])
    merged_ranges
end

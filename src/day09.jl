function positions(m::AbstractMatrix)
    rows, cols = size(m)
    function producer(ch::Channel)
        for r in 1:rows
            for c in 1:cols
                put!(ch, (r,c))
            end
        end
    end
    return Channel(producer)
end

function valid_position(m::AbstractMatrix, pos)
    rows, cols = size(m)
    r, c = pos
    return 1 ≤ r ≤ rows && 1 ≤ c ≤ cols
end

function neighbors(m::AbstractMatrix, pos)
    nbs = []
    r,c = pos
    valid_position(m, (r + 1, c)) && push!(nbs, (r + 1, c))
    valid_position(m, (r - 1, c)) && push!(nbs, (r - 1, c))
    valid_position(m, (r, c + 1)) && push!(nbs, (r, c + 1))
    valid_position(m, (r, c - 1)) && push!(nbs, (r, c - 1))
    return nbs
end

is_low(m::AbstractMatrix, pos) = all(m[nb...] > m[pos...] for nb in neighbors(m, pos))
low_points(m::AbstractMatrix) = [pos for pos in positions(m) if is_low(m, pos)]

function day09a(heights)
    return sum(heights[pos...]+1 for pos in low_points(heights))
end

function basin_area(heights::AbstractMatrix, pos)
    basin = Set()
    stack = [pos]
    while !isempty(stack)
        current = pop!(stack)
        !valid_position(heights, current) && continue 
        current ∈ basin && continue
        heights[current...] == 9 && continue
        push!(basin, current)
        append!(stack, neighbors(heights, current))
    end
    return length(basin)
end

function day09b(heights)
    basin_sizes = [basin_area(heights, p) for p in low_points(heights)]
    sort!(basin_sizes, rev = true)
    return prod(basin_sizes[1:3])
end

function day09(io)
    heights = parse_matrix(io)
    p1 = day09a(heights)
    p2 = day09b(heights)
    return (p1, p2)
end

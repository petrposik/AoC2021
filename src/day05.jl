ishorizontal(s::Segment) = s.p1[2]==s.p2[2]
isvertical(s::Segment) = s.p1[1]==s.p2[1]

function draw_segment!(field, s::Segment)
    start, goal = s.p1, s.p2
    field[start[2], start[1]] += 1
    dif = sign.(goal - start)
    current = start
    while current != goal
        current += dif
        field[current[2], current[1]] += 1
    end
end

function day05a(segments; include_diagonals=false)
    field = zeros(Int8, 1000, 1000)
    for s in segments
        if include_diagonals || ishorizontal(s) || isvertical(s)
            draw_segment!(field, s)
        end
    end
    return length(findall(field .> 1))
end

function day05b(segments)
    return day05a(segments, include_diagonals=true)
end

function day05(io)
    segments = parse_segments(io)
    return (day05a(segments), day05b(segments))
end

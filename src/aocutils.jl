using Base: readlines
using Base: ==

function parse_matrix(io)
    rows = []
    for line in eachline(io)
        push!(rows, parse.(Int8, collect(line)))
    end
    return transpose(hcat(rows...))
end

function parse_point(s::AbstractString)
    nums = split(s, ',')
    return [parse(Int, nums[1])+1, parse(Int, nums[2])+1]
end

struct Segment
    p1 :: Vector{Int}
    p2 :: Vector{Int}
end

function parse_segment(s::AbstractString)
    parts = split(s)
    # Intentionally leave out parts[2], it is "->"
    return Segment(parse_point(parts[1]), parse_point(parts[3]))
end

function Base.:(==)(s1::Segment, s2::Segment)
    return s1.p1 == s2.p1 && s1.p2 == s2.p2
end

function parse_segments(io)
    return parse_segment.(readlines(io))
end

"Split a text file by empty lines and return all the parts as list of strings each."
function parse_parts(io)
    segments = []
    segment = []
    for line in eachline(io)
        line = strip(line)
        if isempty(line)
            if !isempty(segment)
                push!(segments, segment)
            end
            segment = []
        else
            push!(segment, line)
        end
    end
    if !isempty(segment)
        push!(segments, segment)
    end
    return segments
end

mutable struct Bingo
    numbers::Vector{Int}
    boards::Vector{Matrix{Int}}
end

parse_ints_from_row(str; sep = " ") = parse.(Int, split(str, sep, keepempty = false))

function parse_bingo(fpath::AbstractString)
    segments = parse_parts(fpath)
    nbrs = parse_ints_from_row(segments[1][1], sep=',')
    boards = parse_bingo_board.(segments[2:end])
    return Bingo(nbrs, boards)
end

function parse_bingo_board(segment)
    rows = parse_ints_from_row.(segment)
    return vcat((rows')...)
end

parseint(x) = parse(Int, x)

function parsebinary(fpath::AbstractString)
    lines = readlines(fpath)
    binmatrix = parse.(Int, reduce(vcat, permutedims.(collect.(lines))))
    return binmatrix
end

function parseints(fpath::AbstractString)
    lines = readlines(fpath)
    numbers = parseint.(lines)
    return numbers
end

function parsecommand(line::AbstractString)
    parts = split(line, limit = 2)
    return (parts[1], parseint(parts[2]))
end

function parsecommands(fpath::AbstractString)
    lines = readlines(fpath)
    return [parsecommand(line) for line ∈ lines]
end

function readmatrix(filename::AbstractString)
    lines = readlines(filename)
    mat = Array{Char}(undef, length(lines), length(lines[1]))
    for (r, row) in enumerate(lines)
        for (c, item) in enumerate(row)
            mat[r, c] = item
        end
    end
    return mat
end

function item(mat::Matrix, r::Int, c::Int)
    n_rows, n_columns = size(mat)
    c = mod(c - 1, n_columns) + 1
    return mat[r, c]
end
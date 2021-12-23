#      acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
# srt: abcdefg bcdef acdfg abcdf abd abcdef bcdefg abef abcdeg ab | bcdef abcdf bcdef abcdf
# len:    7      5    5      5    3    6      6     4     6    2      5     5     5     5
# num:    8     235  235    235   7   069    069    4    069   1     235   235   235   235
# Because ab is 1, then a 5group containing ab must be 3,
#                   and a 6group missing a or b must be 6.
# num:    8     25   25      3    7    09     09    4     6    1     25     3    25    3


# All the following definitions shall be equivalent
# normalize(x) = join(sort(collect(x)))
# normalize = join ∘ sort ∘ collect
normalize(x) = x |> collect |> sort |> join

num2seg = Dict(0 => "abcefg", 1 => "cf", 2 => "acdeg", 3 => "acdfg", 4 => "bcdf",
               5 => "abdfg", 6 => "abdefg", 7 => "acf", 8 => "abcdefg", 9 => "abcdfg")

function parse_7segments(io)
    signals = []
    quartets = []
    for line in eachline(io)
        left, right = split(line,'|')
        push!(signals, normalize.(split(left)))
        push!(quartets, normalize.(split(right)))
    end
    return signals, quartets
end

unique_patterns = Set([2, 4, 3, 7])  # 1,4,7,8 use a unique number of segments
is_unique(p) = p in unique_patterns

function day08a(quartets)
    return sum(count(is_unique, length.(nums)) for nums in quartets)
end

function invert(d::Dict)
    out = Dict()
    for (k, v) in d
        out[v] = k
    end
    return out
end

function find_encoding(signals)
    sigs = Dict()
    sigs[1] = first(s for s in signals if length(s) == 2)
    sigs[4] = first(s for s in signals if length(s) == 4)
    sigs[7] = first(s for s in signals if length(s) == 3)
    sigs[8] = first(s for s in signals if length(s) == 7)
    # Groups of 5 (3, 2, 5):
    len5 = [s for s in signals if length(s) == 5]
    # Because ab is 1, then a 5group containing ab must be 3,
    sigs[3] = first(s for s in len5 if length(s ∩ sigs[1]) == 2)
    # Decide between 2 and 5: 2 has 2 common elements with 4, 5 has 3 common elements with 4
    sigs[2] = first(s for s in len5 if s != sigs[3] && length(s ∩ sigs[4]) == 2)
    sigs[5] = first(s for s in len5 if s != sigs[3] && length(s ∩ sigs[4]) == 3)
    # Groups of 6 (0, 6, 9):
    len6 = [s for s in signals if length(s) == 6]
    # Because ab is 1, then a 6group missing a or b must be 6.
    sigs[6] = first(s for s in len6 if length(s ∩ sigs[1]) == 1)
    # Deciding between 0 and 9: 0 has 3 common elements with 4, 9 has 4 common elements with 4.
    sigs[0] = first(s for s in len6 if s != sigs[6] && length(s ∩ sigs[4]) == 3)
    sigs[9] = first(s for s in len6 if s != sigs[6] && length(s ∩ sigs[4]) == 4)

    return invert(sigs)
end

function decode(sig2num, sig)
    total = 0
    for (i, s) in enumerate(sig)
        ex = length(sig)-i
        total += sig2num[s] * 10^ex
    end
    return total
end

function day08b(signals, quartets)
    total = 0
    for (sig, q) in zip(signals, quartets)
        sig2num = find_encoding(sig)
        value = decode(sig2num, q)
        total += value
    end
    return total
end

function day08(io)
    signals, quartets = parse_7segments(io)
    p1 = day08a(quartets)
    p2 = day08b(signals, quartets)
    return (p1, p2)
end

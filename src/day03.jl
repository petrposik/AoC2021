using Test
using Statistics

function bin2dec(b)
    return sum(bit * 2^(ex-1) for (ex, bit) in enumerate(reverse(b)))
end

"In a vector of 0s and 1s, return the more frequent symbol."
function morefrequent(vec)
    nones = sum(vec)
    n = length(vec)
    return nones >= length(vec)-nones ? 1 : 0
end

function gamma_epsilon(bm)
    binary_gamma = [morefrequent(c) for c in eachcol(bm)]
    binary_epsilon = [1-bit for bit in binary_gamma]
    return bin2dec(binary_gamma), bin2dec(binary_epsilon)
end


function day03a(bm)
    gam, eps = gamma_epsilon(bm)
    return gam*eps
end

function filterrows(f::Function, bm)
    i = 0
    while size(bm)[1] > 1
        i += 1
        bit = f(bm[:,i])
        bm = bm[ bm[:,i].==bit , :]
    end
    return bin2dec(bm[1,:])
end

function oxygen(bm)
    result = filterrows(bm) do col
        morefrequent(col)
    end
    return result
end

function co2(bm)
    result = filterrows(bm) do col
        1-morefrequent(col)
    end
    return result
end

function day03b(bm)
    ox = oxygen(bm)
    co = co2(bm)
    return ox * co
end

function day03(fpath)
    bm = parsebinary(fpath)
    return (day03a(bm), day03b(bm))
end

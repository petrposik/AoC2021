

function parse_positions(io)
    lines = readlines(io)
    return parse_ints_from_row(lines[1]; sep=",")
end

function fuelb(dist)
    return dist*(dist+1)/2
end

function consumed_fuel(positions, target; fuel_func=identity)
    return sum(fuel_func(abs(p-target)) for p in positions)
end

function median(values)
    svals = sort(values)
    n = length(svals)
    return svals[div(n, 2, RoundNearest)]
end

function day07a(positions)
    med = median(positions)
    return consumed_fuel(positions, med)
end

# Analytical solution to minimize_p sum_{x\in X} (x-p)(x-p+1)/2
# The minimizer shall be p = (2s+n)/(2n) where s = sum(X) and n = length(X).
# But it gives wrong result for the B part, and I do not know why.
# The minimizer is somewhere between 464 and 465, but the above computation returns 465.009...
# If the +n part is removed from the numerator, we have computation for the mean.
# But mean is a minimizer for sum x^2, which is not exactly what we are optimizing here...

function day07b_analytical(positions)
    f(p) = consumed_fuel(positions, p, fuel_func = fuelb)
    m = minimizer(positions)
    m1, m2 = Int(round(m, RoundDown)), Int(round(m, RoundUp))
    f1 = f(m1)
    f2 = f(m2)
    return convert(Int, min(f1, f2))
end

function minimizer(values)
    n = length(values)
    s = sum(values)
    return (2s + n) / (2n)
end

function day07b(positions)
    left, right = minimum(positions), maximum(positions)
    f(p) = consumed_fuel(positions, p, fuel_func = fuelb)
    popt = argmin(f, left:right)
    return convert(Int, f(popt))
end

function day07(io)
    positions = parse_positions(io)
    return (day07a(positions), day07b(positions))
end

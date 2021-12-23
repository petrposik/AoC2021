

function parse_ages(io)
    lines = readlines(io)
    return parse_ints_from_row(lines[1]; sep=",")
end


function ages_to_counters(ages)
    return [sum(ages .== i) for i in 0:8]
end

function step_ages(ages)
    counters = ages_to_counters(ages)
    return step_counters(counters)
end

function step_counters(counters)
    n_new = counters[1]
    for i in 1:8
        counters[i] = counters[i+1]
    end
    counters[9] = 0
    if n_new > 0
        counters[7] += n_new
        counters[9] = n_new
    end
    return counters
end

function step_n_ages(days, ages)
    counters = ages_to_counters(ages)
    return step_n_counters(days, counters)
end

function step_n_counters(days, counters)
    for i in 1:days
        counters = step_counters(counters)
        # println(counters)
    end
    return counters
end

function day06a(counters)
    counters = step_n_counters(80, counters)
    return sum(counters)
end

function day06b(counters)
    counters = step_n_counters(256, counters)
    return sum(counters)
end

function day06(io)
    ages = parse_ages(io)
    counters = ages_to_counters(ages)
    return (day06a(copy(counters)), day06b(copy(counters)))
end

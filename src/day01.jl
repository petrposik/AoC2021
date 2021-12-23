function sequence_diff(seq, step=1)
    return [seq[i+step]-seq[i] for i = 1:length(seq)-step]
end

function day01a(numbers)
    diffs = sequence_diff(numbers)
    sum(diffs .> 0)
end

function day01b(numbers)
    diffs = sequence_diff(numbers, 3)
    sum(diffs .> 0)
end

function day01(fpath)
    numbers = parseints(fpath)
    return (day01a(numbers), day01b(numbers))
end
"Take a board and turn each row and column into a set of numbers"
function compose_sets(board)
    sets = []
    for r in eachrow(board)
        push!(sets, Set(r))
    end
    for c in eachcol(board)
        push!(sets, Set(c))
    end
    return sets
end

is_winning(set) = any(s -> isempty(s), set)

function play(bingo; stop_after_first_winner=true)
    sets = compose_sets.(bingo.boards)
    number = nothing
    winner_index = nothing
    winning_number = nothing
    winning_set = nothing
    for number in bingo.numbers
        # Remove number from all sets of all boards
        for board_set in sets
            for s in board_set
                delete!(s, number)
            end
        end
        # Try to find a winner
        winner_indices = findall(is_winning, sets)
        if !isempty(winner_indices)
            winning_number = number
            winning_set = sets[winner_indices[1]]
            deleteat!(sets, winner_indices)
            stop_after_first_winner && break
        end
    end
    return winning_number, reduce(union, winning_set)
end

function day04a(bingo)
    number, remaining = play(bingo)
    return number * sum(remaining)
end

function day04b(bingo)
    number, remaining = play(bingo, stop_after_first_winner = false)
    return number * sum(remaining)
end

function day04(fpath)
    bingo = parse_bingo(fpath)
    return (day04a(bingo), day04b(bingo))
end

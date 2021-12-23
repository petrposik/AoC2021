
function execute_commands_part1(commands)
    dist, depth = 0, 0
    for (command, amount) in commands
        if command == "forward"
            dist += amount
        elseif command == "up"
            depth -= amount
        elseif command == "down"
            depth += amount
        else
            error("Should not happen. Command $command not recognized.")
        end
    end
    return dist, depth
end

function execute_commands_part2(commands)
    dist, depth, aim = 0, 0, 0
    for (command, amount) in commands
        if command == "down"
            aim += amount
        elseif command == "up"
            aim -= amount
        elseif command == "forward"
            dist += amount
            depth += aim * amount
        else
            error("Should not happen. Command $command not recognized.")
        end
    end
    return dist, depth
end

function day02a(commands)
    dist, depth = execute_commands_part1(commands)
    return dist * depth
end

function day02b(commands)
    dist, depth = execute_commands_part2(commands)
    return dist * depth
end

function day02(fpath)
    commands = parsecommands(fpath)
    return (day02a(commands), day02b(commands))
end

# println(parsecommands("test_input_02.txt"))
# println(day02a())
# println(day02b())


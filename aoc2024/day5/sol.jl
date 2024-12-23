using Base: eachline, EachLine

const Rules = Dict{Int,Set{Int}}
const Updates = Vector{Vector{Int}}

function getRule(line::String)::Tuple{Int,Int}
    parts::Vector{String} = split(line, '|')
    return (
        parse(Int, parts[1]),
        parse(Int, parts[2]),
    )
end

function getUpdate(line::String)::Vector{Int}
    map(split(line, ',')) do x
        parse(Int, x)
    end
end

# readline version
function getInput(name::String)::Tuple{Rules,Updates}
    rules::Rules = Dict()
    updates::Updates = Vector()
    open(name) do handle
        line::String = readline(handle)
        while length(line) > 0
            prev::Int, next::Int = getRule(line)
            if !(prev in keys(rules))
                push!(rules, prev => Set())
            end
            push!(rules[prev], next)
            line = readline(handle)
        end
        while !eof(handle)
            line = readline(handle)
            push!(updates, getUpdate(line))
        end
    end
    return (rules, updates)
end

# iterator version (seems faster)
function getInput(name::String)::Tuple{Rules,Updates}
    rules::Rules = Dict()
    updates::Updates = Vector()
    iter::EachLine = eachline(name)
    line::String = first(iter)
    while length(line) > 0
        prev::Int, next::Int = getRule(line)
        if !(prev in keys(rules))
            push!(rules, prev => Set())
        end
        push!(rules[prev], next)
        line = first(iter)
    end
    for line in iter
        push!(updates, getUpdate(line))
    end
    return (rules, updates)
end

function solve1(rules::Rules, updates::Updates)::Int
    sum(map(updates) do update
        for i in length(update):-1:2
            for j in 1:(i-1)
                if update[i] in keys(rules) &&
                   update[j] in rules[update[i]]
                    return 0
                end
            end
        end
        return update[Int(ceil(length(update) / 2))]
    end)
end

function solve1(name::String)::Int
    solve1(getInput(name)...)
end

function repairStep(rules::Rules, update::Vector{Int}, i::Int)::Bool
    repaired::Bool = false
    good::Bool = false
    while !good
        good = true
        for j in 1:(i-1)
            if update[i] in keys(rules) && update[j] in rules[update[i]]
                update[i], update[j] = update[j], update[i]
                repaired = true
                good = false
                break
            end
        end
    end
    return repaired
end

function solve2(rules::Rules, updates::Updates)::Int
    sum(map(updates) do update
        repaired::Bool = false
        for i in length(update):-1:2
            repaired |= repairStep(rules, update, i)
        end
        if !repaired
            return 0
        end
        return update[Int(ceil(length(update) / 2))]
    end)
end

function solve2(name::String)::Int
    solve2(getInput(name)...)
end

# @time solve1("tinput")
# @time solve1("input")

# @time solve2("tinput")
# @time solve2("input")

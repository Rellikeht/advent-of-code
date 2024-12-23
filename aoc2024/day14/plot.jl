using Base: EachLine
using CairoMakie

# function read_data(line::String)::NTuple{2,Vector{Int}}
#     p1::SubString, p2::SubString = eachsplit(line, ':')
#     return (
#         map(p -> parse(Int, p), eachsplit(p1, ' ')),
#         map(p -> parse(Int, p), eachsplit(p2, ' ')),
#     )
# end

function read_data(line::String)::Vector{NTuple{2,Int}}
    return map(eachsplit(line, ' ')) do sub
        p1::SubString, p2::SubString = eachsplit(sub, ',')
        return (parse(Int, p1), parse(Int, p2))
    end
end

function read_data(
    fname::String,
    iterations::Int
    # )::Vector{NTuple{2,Vector{Int}}}
)::Vector{Vector{NTuple{2,Int}}}
    c::Cmd = `./target/debug/generate $fname $iterations`
    iterations += 1
    # result::Vector{NTuple{2,Vector{Int}}} = Vector(undef, iterations)
    result::Vector{Vector{NTuple{2,Int}}} = Vector(undef, iterations)
    open(c, "r") do io
        lines::EachLine = eachline(io)
        for i in 1:iterations
            result[i] = read_data(first(lines))
            # result[i] = read_data(readline(pipe_out))
        end
    end
    return result
end

# function read_data(iterations::Int)::Vector{NTuple{2,Vector{Int}}}
function read_data(iterations::Int)::Vector{Vector{NTuple{2,Int}}}
    read_data("input", iterations)
end

# function read_data()::Vector{NTuple{2,Vector{Int}}}
function read_data()::Vector{Vector{NTuple{2,Int}}}
    read_data("input", 10_000)
end

function animate(frames::Int, name::String)
    robots::Vector{Vector{NTuple{2,Int}}} = @time read_data(frames)
    observable::Observable = Observable(NTuple{2,Int}[])
    title::Observable = Observable("Step 0")
    f = Figure()
    ax = Axis(f[1, 1], title=title)
    scatter!(ax, observable, markersize=4, color="#000")
    limits!(ax, 0, 101, 0, 103)
    @time record(f, name, 1:(frames+1), framerate=60) do frame
        observable[] = robots[frame]
        title[] = "Step $(frame-1)"
    end
end

function animate(frames::Int)
    animate(frames, "robots.mp4")
end

let
    f = Figure()
    ax = Axis(f[1, 1])
    x = 0:200
    plot!(ax, x, (x -> 65 + 103 * x - 114 - 101 * x).(x), markersize=3)
    f
end

using Random
using Distributions
using Plots

mutable struct Position{T <: AbstractFloat}
    x::T
    y::T
end

function generate_data(;number_points::Int64)
    coords = []
    for i in 1:number_points
        posx = rand(Uniform(100, 5000))
        posy = rand(Uniform(100, 5000))
        push!(coords, Position(posx, posy))
    end
    return coords
end

coord = generate_data(number_points=40)

function plot_position(coord)
    
    p = plot([coord[1].x, coord[end].x], [coord[1].y, coord[end].y], color=:skyblue, legend=nothing, linewidth=1.5)
    
    for (pos1, pos2) in zip(coord[1:end - 1], coord[2:end])
        plot!([pos1.x, pos2.x], [pos1.y, pos2.y], color=:skyblue, linewidth=1.5)
    end
    
    for pos1 in coord
        scatter!([pos1.x], [pos1.y], markercolor=:darkgrey, markersize=8, markerstrokecolor=:darkgrey)
    end
    
    xlabel!("x")
    ylabel!("y")
    
    return p
end 

plot_position(coord)

function distance(point1::Position, point2::Position)
    return sqrt((point1.x - point2.x)^2 + (point1.y - point2.y)^2)
end

function total_distance(coord)
    sum(distance.(coord[1:end - 1], coord[2:end])) + distance(coord[1], coord[end])
end
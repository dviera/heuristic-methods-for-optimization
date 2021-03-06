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

function SA(route; initial_temp, markov_len, cooling)
    
    m = length(route)
    new_route = copy(route)
    old_cost = total_distance(route)
    best_route = copy(route)
    best_distance = 0
    
    temp_hist = []
    push!(temp_hist, initial_temp)
    
    cost_hist = []
    push!(cost_hist, old_cost)
    
    T = initial_temp
    
    while T > 0.0

        for i in 1:markov_len

            # random swap between points
            r1, r2 = rand(2:m, 2)
            temp = new_route[r1]
            new_route[r1] = new_route[r2]
            new_route[r2] = temp
            new_cost = total_distance(new_route)

            
            if new_cost < old_cost
                best_route = new_route
                best_distance = new_cost
                old_cost = new_cost
                push!(cost_hist, new_cost)
            else
                u = rand()
                if u < exp((old_cost - new_cost) / T)
                    old_cost = new_cost
                    push!(cost_hist, new_cost)
                else
                    temp = new_route[r1]
                    new_route[r1] = new_route[r2]
                    new_route[r2] = temp
                end
            end

        end

        # decrasing temperature linearly
        # T = T * cooling
        T -= 0.1
        push!(temp_hist, T)

    end
    
    return new_route, temp_hist, cost_hist
    
end

nt, th, ch = SA(coord, initial_temp=150, markov_len=500, cooling=0.99);

plot_position(nt)
plot(collect(1:length(ch)), ch)
minimum(ch)
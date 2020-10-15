include("utils.jl")

data = generate_data(number_points=300);
plot_position(data)
total_distance(data)

function singleTwoOpt(route, i, k)
    [route[1:i - 1];
    reverse(route[i:k]);
    route[k + 1:end]]
end

function twoOpt(route; iters::Int64=10_000)
    """
    iters :: how many iterations without improvements allowed
    route :: a route excluding the depot at the end
    """

    existing_route = copy(route)
    best_distance = total_distance(existing_route)
    new_distance = 0
    m = length(route)
    new_route = []

    counter = 0

    while counter < iters
        for i = 2:m - 1
            for k = i + 1:m - 1
                new_route = singleTwoOpt(existing_route, i, k)
                new_distance = total_distance(new_route)
                if new_distance < best_distance
                    # debug
                    # println(abs(new_distance - best_distance))
                    existing_route = new_route
                    best_distance = new_distance
                else
                    counter += 1
                end
            end
        end
    end

    return existing_route, best_distance
end

@time route2opt, bd = twoOpt(data, iters=500_000);
bd
plot_position(route2opt)











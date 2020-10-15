from random import randint
import matplotlib.pyplot as plt
import random
import math
import numpy as np

class Position:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    @staticmethod
    def distance(point1, point2):
        dis = math.sqrt((point1.x - point2.x)**2 + (point1.y - point2.y)**2)
        return dis

    @staticmethod
    def total_distance(coords):
        total_dis = 0
        for p1, p2 in zip(coords[0:-1], coords[1:]):
            total_dis += Position.distance(p1, p2)
        total_dis += Position.distance(coords[0], coords[-1])
        
        return total_dis


if __name__ == "__main__":

    def generate_coords(n = 10):
        coords = []
        for i in range(n):
            coords.append(Position(random.random(), random.random()))
        return coords

    coords = generate_coords(n = 20)
    
    def plot_route(route):
        
        for p1, p2 in zip(route[0:-1], route[1:]):
            plt.plot([p1.x, p2.x], [p1.y, p2.y], color = "skyblue")
        plt.plot([route[0].x, route[-1].x],  [route[0].y, route[-1].y], color = "skyblue")

        for r in route:
            plt.plot(r.x, r.y, marker = 'o', color = "darkgrey", markersize = 12)
        
        plt.show()

    def SA(route, initial_temp, cooling, markov_len, sim_len):

        temp_hist = []
        cost_hist = []

        m = len(route)
        
        T = initial_temp

        old_cost = Position.total_distance(route)

        cost_hist.append(old_cost)

        for i in range(sim_len):
            
            # debug
            # print(f"Simulation n° {i} with cost {old_cost}")

            temp_hist.append(T)

            for j in range(markov_len):

                r1, r2 = random.sample(range(1, m), 2)
                temp = route[r1]
                route[r1] = route[r2]
                route[r2] = temp
                new_cost = Position.total_distance(route)

                if new_cost < old_cost:
                    old_cost = new_cost

                else:
                    u = random.random()
                    if u < np.exp((old_cost - new_cost) / T):
                        old_cost = new_cost
                    else:
                        temp = route[r1]
                        route[r1] = route[r2]
                        route[r2] = temp

            # debug
            # overflow using math.exp
            # print(f"exp overflow {np.exp(delta / T)}")

            T = cooling * T

        return route, cost_hist, temp_hist

    rt, ch, th = SA(route = coords, initial_temp = 30, cooling = 0.99, markov_len = 500, sim_len = 1000)

    plot_route(rt)
import matplotlib.pyplot as plt
import numpy as np
import random
import time
from heapq import heappop, heappush

SIZE = 8
OFFSET = 0
DENS = 0.5


class Space:
    def __init__(self, width, height, depth):
        self.size = (width, height, depth)
        self.obstacles = set()

    def is_valid(self, point):
        x, y, z = point
        return 0 <= x < self.size[0] and 0 <= y < self.size[1] and 0 <= z < self.size[2]

    def add_obstacle(self, point):
        if self.is_valid(point):
            self.obstacles.add(point)

    def generate_obstacles(self, density):
        for x in range(self.size[0]):
            for y in range(self.size[1]):
                for z in range(self.size[2]):
                    if np.random.rand() < density:
                        self.add_obstacle((x, y, z))

    def is_obstacle(self, point):
        return point in self.obstacles


class PathFinder:
    def __init__(self, space, start, end):
        self.space = space
        self.start = start
        self.end = end
        self.directions = [(0, 0, 1), (0, 0, -1), (0, 1, 0), (0, -1, 0), (1, 0, 0), (-1, 0, 0)]

    def heuristic(self, a, b):
        return abs(a[0] - b[0]) + abs(a[1] - b[1]) + abs(a[2] - b[2])

    def a_star_search(self):
        open_list = [(0, self.start)]
        came_from = {}
        g_score = {self.start: 0}

        while open_list:
            current_score, current = heappop(open_list)

            if current == self.end:
                return self.generate_path(came_from, self.end)

            for direction in self.directions:
                next_point = (current[0] + direction[0], current[1] + direction[1], current[2] + direction[2])

                if not self.space.is_valid(next_point) or self.space.is_obstacle(next_point):
                    continue

                new_g_score = g_score[current] + 1

                if next_point not in g_score or new_g_score < g_score[next_point]:
                    g_score[next_point] = new_g_score
                    f_score = new_g_score + self.heuristic(next_point, self.end)
                    heappush(open_list, (f_score, next_point))
                    came_from[next_point] = current

        return None  # No path found

    def generate_path(self, came_from, end):
        current = end
        path = []
        while current in came_from:
            path.append(current)
            current = came_from[current]
        path.append(self.start)
        path.reverse()
        return path


class Visualizer:
    def __init__(self, space, path):
        self.space = space
        self.path = path

    def plot_path(self):
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')

        # xs = [point[0] for point in self.path]
        # ys = [point[1] for point in self.path]
        # zs = [point[2] for point in self.path]
        #
        # ax.plot(xs, ys, zs, marker='o', linestyle='-', color='b')

        # Plot path as blue blocks
        if path:
            path_x, path_y, path_z = zip(*path)
            for i in range(len(path_x)):
                x, y, z = path_x[i], path_y[i], path_z[i]
                # ax.bar3d(x - 0.25, y - 0.25, z - 0.25, 0.5, 0.5, 0.5, color='blue', alpha=0.7)
                if i > 0:
                    prev_x, prev_y, prev_z = path_x[i - 1], path_y[i - 1], path_z[i - 1]
                    mid_x, mid_y, mid_z = (x + prev_x) / 2, (y + prev_y) / 2, (z + prev_z) / 2
                    ax.bar3d([prev_x - 0.25, mid_x - 0.25, x - 0.25], [prev_y - 0.25, mid_y - 0.25, y - 0.25],
                             [prev_z - 0.25, mid_z - 0.25, z - 0.25], 0.5, 0.5, 0.5, color='blue', alpha=0.7)

        for obstacle in self.space.obstacles:
            # ax.scatter(*obstacle, c='r', marker='x', s=100)
            ax.bar3d(*np.subtract(obstacle, 0.5), 1, 1, 1, color='red', alpha=0.1)

        ax.set_xlabel('X')
        ax.set_ylabel('Y')
        ax.set_zlabel('Z')

        ax.set_xlim(0, max(space.size) - 1)
        ax.set_ylim(0, max(space.size) - 1)
        ax.set_zlim(0, max(space.size) - 1)

        plt.show()


# t = time.perf_counter()
# # Define the 3D space dimensions
# # space_size = (SIZE, SIZE, SIZE)
#
# # Define the start and end points
# start = (random.randint(0, OFFSET), random.randint(0, OFFSET), random.randint(0, OFFSET))
# end = (random.randint(SIZE - OFFSET, SIZE) - 1,
#        random.randint(SIZE*2 - OFFSET, SIZE*2) - 1,
#        random.randint(SIZE - OFFSET, SIZE) - 1)
#
# # Create the space and pathfinder objects
# space = Space(SIZE, SIZE*2, SIZE)
# path_finder = PathFinder(space, start, end)
#
# # Generate obstacles randomly with density 0.1 (10%)
# space.generate_obstacles(DENS)
#
# # Call the pathfinding function
# path = path_finder.a_star_search()
# print(f"Start :{start}, End :{end}")
# print(f"Elapsed time : {(time.perf_counter() - t) * 1e3} ms")
# if path:
#     # print("Path found:")
#     # print(path)
#
#     # Create the visualizer object and plot the result
#     visualizer = Visualizer(space, path)
#     visualizer.plot_path()
# else:
#     print("No path found.")

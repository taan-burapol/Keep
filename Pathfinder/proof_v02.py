import heapq
import math
import time
import random
import numpy as np
import matplotlib.pyplot as plt
# from mpl_toolkits.mplot3d import Axes3D

SIZE = 8
OFFSET = 0
DENS = 0.1


class Node:
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z
        self.g = 0
        self.h = 0
        self.parent = None

    def __lt__(self, other):
        return self.g + self.h < other.g + other.h


def calculate_heuristic(node, end):
    return abs(end.x - node.x) + abs(end.y - node.y) + abs(end.z - node.z)


class AStar3D:
    def __init__(self, width, height, depth):
        self.width = width
        self.height = height
        self.depth = depth
        # self.grid = [[[0 for _ in range(depth)] for _ in range(height)] for _ in range(width)]
        self.grid = np.zeros((width, height, depth))

    def plot_3d_space(self, path=None):
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')

        # Plot obstacles as red cubes
        for x in range(self.width):
            for y in range(self.height):
                for z in range(self.depth):
                    if self.grid[x][y][z] == 1:
                        ax.bar3d(x - 0.5, y - 0.5, z - 0.5, 1, 1, 1, color='red', alpha=0.1)

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

        # # Plot path as a blue line
        # if path:
        #     path_x, path_y, path_z = zip(*path)
        #     ax.plot(path_x, path_y, path_z, color='blue', marker='o')

        ax.set_xlabel('X')
        ax.set_ylabel('Y')
        ax.set_zlabel('Z')

        ax.set_xlim(0, self.width - 1)
        ax.set_ylim(0, self.height - 1)
        ax.set_zlim(0, self.depth - 1)

        plt.show()

    def set_obstacle(self, x, y, z):
        if self.is_valid(x, y, z):
            self.grid[x][y][z] = 1

    def is_valid(self, x, y, z):
        return 0 <= x < self.width and 0 <= y < self.height and 0 <= z < self.depth and self.grid[x][y][z] == 0

    def get_neighbors(self, node):
        x, y, z = node.x, node.y, node.z
        neighbors = [
            (x + 1, y, z), (x - 1, y, z),
            (x, y + 1, z), (x, y - 1, z),
            (x, y, z + 1), (x, y, z - 1)
        ]
        return [neighbor for neighbor in neighbors if self.is_valid(*neighbor)]

    def find_path(self, start_x, start_y, start_z, end_x, end_y, end_z):
        start_node = Node(start_x, start_y, start_z)
        end_node = Node(end_x, end_y, end_z)

        open_list = []
        closed_set = set()
        heapq.heappush(open_list, start_node)

        while open_list:
            current_node = heapq.heappop(open_list)

            if current_node.x == end_x and current_node.y == end_y and current_node.z == end_z:
                path = []
                while current_node:
                    path.append((current_node.x, current_node.y, current_node.z))
                    current_node = current_node.parent
                return path[::-1]

            closed_set.add((current_node.x, current_node.y, current_node.z))

            for neighbor_pos in self.get_neighbors(current_node):
                x, y, z = neighbor_pos
                if (x, y, z) in closed_set:
                    continue

                neighbor = Node(x, y, z)
                neighbor.g = current_node.g + 1
                neighbor.h = calculate_heuristic(neighbor, end_node)
                neighbor.parent = current_node

                if neighbor in open_list:
                    existing_neighbor = open_list[open_list.index(neighbor)]
                    if neighbor.g < existing_neighbor.g:
                        existing_neighbor.g = neighbor.g
                        existing_neighbor.parent = neighbor.parent
                else:
                    heapq.heappush(open_list, neighbor)

        return None


def create_3d_space_with_obstacles():
    def add_random_obstacles(self, density):
        num_obstacles = math.ceil(density * self.width * self.height * self.depth)
        for _ in range(num_obstacles):
            x, y, z = random.randint(0,
                                     self.width - 1), random.randint(0,
                                                                     self.height - 1), random.randint(0,
                                                                                                      self.depth - 1)
            self.set_obstacle(x, y, z)
        return self

    # Create a 5x5x5 3D space
    space = AStar3D(SIZE, SIZE, SIZE)
    if DENS > 0:
        space = add_random_obstacles(space, density=DENS)

    # Add obstacles to the grid
    # space.set_obstacle(1, 0, 0)
    # space.set_obstacle(1, 0, 1)
    # space.set_obstacle(1, 2, 0)
    # space.set_obstacle(1, 3, 0)
    # space.set_obstacle(1, 4, 0)
    # space.set_obstacle(3, 1, 0)
    # space.set_obstacle(3, 2, 0)
    # space.set_obstacle(3, 3, 0)
    # space.set_obstacle(3, 4, 0)

    return space


def find_shortest_path(space, start_x, start_y, start_z, end_x, end_y, end_z):
    return space.find_path(start_x, start_y, start_z, end_x, end_y, end_z)


t = time.perf_counter()
# Example usage
space = create_3d_space_with_obstacles()

start = (random.randint(0, OFFSET), random.randint(0, OFFSET), random.randint(0, OFFSET))
end = (random.randint(SIZE-OFFSET, SIZE) - 1,
       random.randint(SIZE-OFFSET, SIZE) - 1,
       random.randint(SIZE-OFFSET, SIZE) - 1)
path = find_shortest_path(space, *start, *end)
print(f"Start :{start}, End :{end}")
print(f"Elapsed time : {(time.perf_counter() - t) * 1e3} ms")
if path:
    # print("Shortest path:")
    # for point in path:
    #     print(point)

    # Plot the 3D space and the path
    space.plot_3d_space(path)
else:
    print("No path found.")

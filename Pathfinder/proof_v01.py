import heapq
import matplotlib.pyplot as plt


class Node:
    def __init__(self, position, parent=None):
        self.position = position
        self.parent = parent
        self.g = 0
        self.h = 0

    def __lt__(self, other):
        return (self.g + self.h) < (other.g + other.h)


def manhattan_distance(start, end):
    return abs(end[0] - start[0]) + abs(end[1] - start[1]) + abs(end[2] - start[2])


def get_neighbors(position, size):
    x, y, z = position
    neighbors = [(x + 1, y, z), (x - 1, y, z), (x, y + 1, z), (x, y - 1, z), (x, y, z + 1), (x, y, z - 1)]
    return [(nx, ny, nz) for nx, ny, nz in neighbors if 0 <= nx < size and 0 <= ny < size and 0 <= nz < size]


def reconstruct_path(node):
    path = []
    current = node
    while current is not None:
        path.append(current.position)
        current = current.parent
    return list(reversed(path))


def a_star(start, end, size):
    open_set = []
    closed_set = set()

    start_node = Node(start)
    end_node = Node(end)

    heapq.heappush(open_set, start_node)

    while open_set:
        current_node = heapq.heappop(open_set)
        closed_set.add(current_node.position)

        if current_node.position == end:
            return reconstruct_path(current_node)

        for neighbor in get_neighbors(current_node.position, size):
            if neighbor in closed_set:
                continue

            neighbor_node = Node(neighbor, current_node)
            neighbor_node.g = current_node.g + 1
            neighbor_node.h = manhattan_distance(neighbor, end)

            if neighbor_node not in open_set:
                heapq.heappush(open_set, neighbor_node)

    return None


def plot_3d_grid(start, end, path, size):
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')

    # Grid points
    x, y, z = zip(*path)
    ax.scatter(x, y, z, color='g', label='Path')

    # Draw line segments between consecutive points in the path
    for i in range(1, len(path)):
        x_values = [path[i-1][0], path[i][0]]
        y_values = [path[i-1][1], path[i][1]]
        z_values = [path[i-1][2], path[i][2]]
        ax.plot(x_values, y_values, z_values, 'g')

    ax.scatter(start[0], start[1], start[2], color='b', label='Start')
    ax.scatter(end[0], end[1], end[2], color='r', label='End')

    # Grid lines
    for i in range(size):
        for j in range(size):
            for k in range(size):
                ax.plot([i], [j], [k], 'ko')

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    ax.legend()

    plt.show()


def main():
    grid_size = 6  # Change this value to adjust the size of the grid
    start_position = (0, 0, 0)
    end_position = (grid_size - 1, grid_size - 1, grid_size - 1)

    path = a_star(start_position, end_position, grid_size)
    if path:
        print("Shortest path:")
        print(path)
        plot_3d_grid(start_position, end_position, path, grid_size)
    else:
        print("No path found.")


if __name__ == "__main__":
    main()

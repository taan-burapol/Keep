import proof_v02
import time
import random


class RandomNumberPairGenerator:
    def __init__(self):
        self.previous_combinations = []

    def generate_random_pair(self):
        valid_numbers = [(num1, num2) for num1 in range(8) for num2 in range(9)
                         if (num1, num2) not in self.previous_combinations]
        if not valid_numbers:
            raise ValueError("All number pairs have been exhausted.")

        random_pair = random.choice(valid_numbers)
        self.previous_combinations.append(random_pair)
        return random_pair


obstacles = []
rng_start = RandomNumberPairGenerator()
rng_end = RandomNumberPairGenerator()
while True:
    t = time.perf_counter()
    space = proof_v02.AStar3D(16, 8, 8)
    try:

        start = (0, *rng_start.generate_random_pair())
        end = (15, *rng_end.generate_random_pair())
    except ValueError:
        break
    if obstacles:
        for obstacle in obstacles:
            if obstacle == start:
                # print(obstacle, start)
                continue
            if obstacle == end:
                # print(obstacle, end)
                continue
            space.set_obstacle(*obstacle)
    path = proof_v02.find_shortest_path(space, *start, *end)
    print(f"Elapsed time : {(time.perf_counter() - t) * 1e3} ms")
    if path:
        # print("Shortest path:")
        # for point in path:
        #     print(point)

        # Plot the 3D space and the path
        space.plot_3d_space(path)
        for obstacle in path:
            obstacles.append(obstacle)
    else:
        print("No path found.")

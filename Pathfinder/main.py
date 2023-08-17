import os
import csv
import main_core
import time
import random

WIDTH = 64
HEIGHT = 64
DEPTH = 64


class RandomNumberPairGenerator:
    def __init__(self):
        self.previous_combinations = []

    def generate_random_pair(self):
        valid_numbers = [(num1, num2) for num1 in range(HEIGHT) for num2 in range(DEPTH)  # num2 -> n + 1
                         if (num1, num2) not in self.previous_combinations]
        if not valid_numbers:
            raise ValueError("All number pairs have been exhausted.")

        random_pair = random.choice(valid_numbers)
        self.previous_combinations.append(random_pair)
        return random_pair


# CSV file path
csv_file_path = 'data.csv'
if os.path.exists(csv_file_path):
    os.remove(csv_file_path)

output_folder = 'plot'  # Name of the output folder

# Remove existing files in the output folder
if os.path.exists(output_folder):
    for file in os.listdir(output_folder):
        file_path = os.path.join(output_folder, file)
        if os.path.isfile(file_path):
            os.remove(file_path)

# Create the output folder if it doesn't exist
os.makedirs(output_folder, exist_ok=True)
obstacles = []
rng_start = RandomNumberPairGenerator()
rng_end = RandomNumberPairGenerator()

while True:
    t = time.perf_counter()
    space = main_core.AStar3D(WIDTH, HEIGHT, DEPTH)
    try:

        start = (0, *rng_start.generate_random_pair())
        end = (WIDTH - 1, *rng_end.generate_random_pair())
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
    path = main_core.find_shortest_path(space, *start, *end)
    print(f"Elapsed time : {(time.perf_counter() - t) * 1e3} ms")
    t = time.perf_counter()
    # Append the new row to the CSV file
    if path:
        with open(csv_file_path, 'a', newline='') as csvfile:
            csv_writer = csv.writer(csvfile)
            csv_writer.writerow(path)

    # if path:
    #     # Plot the 3D space and the path
    #     space.plot_3d_space(path)
    #     for obstacle in path:
    #         obstacles.append(obstacle)
    # else:
    #     print("No path found.")
    # print(f"{' ' * 40}\tPlot time : {(time.perf_counter() - t) * 1e3} ms")

import os
import matplotlib.pyplot as plt
import matplotlib.animation as animation

output_folder = 'plot'  # Name of the output folder


def animate(frame):
    plt.clf()
    plt.imshow(plt.imread(os.path.join(output_folder, f'figure_{frame:02d}.png')))
    plt.title(f'Frame {frame}')


# Get the list of saved files in the output folder
saved_files = [file for file in os.listdir(output_folder) if file.startswith('figure_')]
num_frames = len(saved_files)

ani = animation.FuncAnimation(plt.figure(), animate, frames=num_frames, interval=100)
plt.show()

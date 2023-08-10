import re
from mayavi import mlab

csv_file_path = 'data.csv'
data_list = []

# Regular expression pattern to extract numbers enclosed in parentheses
pattern = r'\((.*?)\)'

with open(csv_file_path, 'r') as csv_file:
    for line in csv_file:
        # Find all matches of the pattern in the line
        matches = re.findall(pattern, line)

        # Convert each match to a list of tuples of integers
        line_data = [tuple(map(int, match.split(','))) for match in matches]

        data_list.append(line_data)

paths = data_list


# Keep track of selected path
selected_path_index = None


# Create a callback function for picking
def picker_callback(picker_cb):
    global selected_path_index
    for i, line_cb in enumerate(lines):
        line_cb.actor.property.opacity = 0.1
        line_cb.actor.property.color = (0.8, 0.5, 0.5)
        if picker_cb.actor in line_cb.actor.actors:
            line_cb.actor.property.opacity = 1
            line_cb.actor.property.color = (1, 0, 0)
            selected_path_index = i


# Create a figure
fig = mlab.figure(size=(800, 800), bgcolor=(0.1, 0.1, 0.1))

# Plot the paths
lines = []
for path in paths:
    x, y, z = zip(*path)
    line = mlab.plot3d(x, y, z, color=(0.8, 0.5, 0.5), tube_radius=None)
    lines.append(line)

# Set up picker_cb
picker = fig.on_mouse_pick(picker_callback)

# Customize the appearance of the plot axes
mlab.axes(
    color=(0.5, 0.5, 0.5),  # Axis color
    line_width=1,  # Axis line width
    xlabel='X Label',  # Label for X-axis
    ylabel='Y Label',  # Label for Y-axis
    zlabel='Z Label',  # Label for Z-axis
    nb_labels=5,  # Number of tick labels
)

# Set labels and title
mlab.xlabel('X')
mlab.ylabel('Y')
mlab.zlabel('Z')
mlab.title('Interactive Paths Plot', size=0.5)
# Set the visualization parameters
mlab.view(azimuth=45, elevation=45, distance=90)

# Show the plot
mlab.show()

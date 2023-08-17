import re
from mayavi import mlab

from traits.api import HasTraits, Button
from traitsui.api import View, UItem, HGroup

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
fig = mlab.figure(size=(800, 600), bgcolor=(0.1, 0.1, 0.1))

x_min = []
y_min = []
z_min = []
x_max = []
y_max = []
z_max = []

# Plot the paths
lines = []
for path in paths:
    x, y, z = zip(*path)
    x_min.append(min(x))
    y_min.append(min(y))
    z_min.append(min(z))
    x_max.append(max(x))
    y_max.append(max(y))
    z_max.append(max(z))
    line = mlab.plot3d(x, y, z, color=(0.8, 0.5, 0.5), tube_radius=None, opacity=0.1)
    lines.append(line)

# Set up picker_cb
picker = fig.on_mouse_pick(picker_callback)

# Customize the appearance of the plot axes
axes = mlab.axes(
    color=(0.5, 0.5, 0.5),  # Axis color
    line_width=1,  # Axis line WIDTH
    xlabel='X Label',  # Label for X-axis
    ylabel='Y Label',  # Label for Y-axis
    zlabel='Z Label',  # Label for Z-axis
    nb_labels=9,  # Number of tick labels
    extent=[min(x_min), max(x_max), min(y_min), max(y_max), min(z_min), max(z_max)]
)
axes.axes.font_factor = 1  # Adjust this value to change the font size

# Set labels and title
mlab.xlabel('X')
mlab.ylabel('Y')
mlab.zlabel('Z')
mlab.title('Interactive Paths Plot', size=0.2)
# Set the visualization parameters
mlab.view(azimuth=45, elevation=45, distance='auto', focalpoint='auto')
mlab.gcf().scene.parallel_projection = True

# Show the plot
mlab.show()

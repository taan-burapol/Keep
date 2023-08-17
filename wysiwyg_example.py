import tkinter as tk
from tkinter import ttk
from tkinter.colorchooser import askcolor


class PixelArtPainter:
    def __init__(self, root, width, height, pixel_size=10):
        self.root = root
        self.root.title("Pixel Art Painter")

        self.style = ttk.Style()
        self.style.configure("TButton", padding=0, relief="flat", background="#ccc")
        self.style.map("TButton", background=[("active", "#aaa")])

        self.canvas = tk.Canvas(self.root, width=width, height=height, bg='white')
        self.canvas.pack()

        self.pixel_size = pixel_size
        self.pixels = {}

        self.color = 'black'
        self.create_palette_button()
        self.create_clear_button()

        self.canvas.bind("<Button-1>", self.start_drawing)
        self.canvas.bind("<B1-Motion>", self.draw_pixel)
        self.canvas.bind("<ButtonRelease-1>", self.stop_drawing)

        self.drawing = False

    def create_palette_button(self):
        palette_button = ttk.Button(self.root, text="Choose Color", command=self.pick_color)
        palette_button.pack()

    def create_clear_button(self):
        clear_button = ttk.Button(self.root, text="Clear Canvas", command=self.clear_canvas)
        clear_button.pack()

    def pick_color(self):
        color = askcolor()[1]
        if color:
            self.color = color

    def clear_canvas(self):
        self.canvas.delete('all')
        self.pixels = {}

    def start_drawing(self, event):
        self.drawing = True
        self.draw_pixel(event)

    def draw_pixel(self, event):
        if self.drawing:
            x = event.x - (event.x % self.pixel_size)
            y = event.y - (event.y % self.pixel_size)

            if (x, y) not in self.pixels:
                pixel = self.canvas.create_rectangle(
                    x, y, x + self.pixel_size, y + self.pixel_size, fill=self.color, outline=self.color
                )
                self.pixels[(x, y)] = pixel

    def stop_drawing(self, event):
        self.drawing = False

    def run(self):
        self.root.mainloop()


if __name__ == "__main__":
    root = tk.Tk()
    app = PixelArtPainter(root, width=200, height=200, pixel_size=5)
    app.run()

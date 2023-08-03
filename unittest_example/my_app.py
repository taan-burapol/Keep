import tkinter as tk


class MyApp:
    def __init__(self, root):
        self.root = root
        self.label = tk.Label(root, text="Hello, Tkinter!")
        self.label.pack()


def main():
    root = tk.Tk()
    MyApp(root)
    root.mainloop()


if __name__ == "__main__":
    main()

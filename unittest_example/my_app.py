import tkinter as tk


class CalculatorApp:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("Calculator")

        self.result_label = tk.Label(self.root, text="Result:")
        self.result_label.pack()

        self.entry1 = tk.Entry(self.root)
        self.entry1.pack()

        self.entry2 = tk.Entry(self.root)
        self.entry2.pack()

        self.add_button = tk.Button(self.root, text="Add", command=self.add)
        self.add_button.pack()

        self.sub_button = tk.Button(self.root, text="Subtract", command=self.subtract)
        self.sub_button.pack()

    def add(self):
        try:
            num1 = float(self.entry1.get())
            num2 = float(self.entry2.get())
            result = num1 + num2
            self.result_label.config(text=f"Result: {result}")
        except ValueError:
            self.result_label.config(text="Error: Invalid input")

    def subtract(self):
        try:
            num1 = float(self.entry1.get())
            num2 = float(self.entry2.get())
            result = num1 - num2
            self.result_label.config(text=f"Result: {result}")
        except ValueError:
            self.result_label.config(text="Error: Invalid input")

    def run(self):
        self.root.mainloop()


if __name__ == "__main__":
    app = CalculatorApp()
    app.run()

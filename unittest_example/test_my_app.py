import unittest
import tkinter as tk
from my_app import CalculatorApp


class TestCalculatorApp(unittest.TestCase):
    def setUp(self):
        self.root = tk.Tk()
        self.app = CalculatorApp()
        self.app.root = self.root

    def tearDown(self):
        self.root.destroy()

    def test_add(self):
        self.app.entry1.insert(0, "5")
        self.app.entry2.insert(0, "10")
        self.app.add()
        self.assertEqual(self.app.result_label.cget("text"), "Result: 15.0")

    def test_subtract(self):
        self.app.entry1.insert(0, "10")
        self.app.entry2.insert(0, "5")
        self.app.subtract()
        self.assertEqual(self.app.result_label.cget("text"), "Result: 5.0")

    def test_invalid_input(self):
        self.app.entry1.insert(0, "Hello")
        self.app.entry2.insert(0, "World")
        self.app.add()
        self.assertEqual(self.app.result_label.cget("text"), "Error: Invalid input")


if __name__ == "__main__":
    unittest.main()

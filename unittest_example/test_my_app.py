import unittest
import tkinter as tk
from tkinter import messagebox
from my_app import MyApp


class TestMyApp(unittest.TestCase):

    def test_my_app_label_text(self):
        root = tk.Tk()
        app = MyApp(root)
        self.assertEqual(app.label.cget("text"), "Hello, Tkinter!")


if __name__ == '__main__':
    unittest.main()

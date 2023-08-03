import unittest
from my_math import add_numbers


class TestMyMath(unittest.TestCase):

    def test_add_numbers_positive(self):
        result = add_numbers(2, 3)
        self.assertEqual(result, 5)

    def test_add_numbers_negative(self):
        result = add_numbers(-2, -3)
        self.assertEqual(result, -5)

    def test_add_numbers_zero(self):
        result = add_numbers(0, 0)
        self.assertEqual(result, 0)

    def test_add_numbers_float(self):
        result = add_numbers(2.5, 3.5)
        self.assertAlmostEqual(result, 6.0, places=1)

    def test_add_numbers_string(self):
        with self.assertRaises(TypeError):
            _ = add_numbers("2", "3")

    def test_add_numbers_list(self):
        with self.assertRaises(TypeError):
            _ = add_numbers([1, 2], [3, 4])


if __name__ == '__main__':
    unittest.main()  # The result should expect as 4 pass and 2 fail.

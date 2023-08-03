import unittest
import os
from selenium import webdriver
from selenium.webdriver.common.by import By


class WebAppTest(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.driver = webdriver.Chrome()
        # Get the absolute path of the HTML file
        file_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "my_web.html"))
        cls.driver.get("file:///" + file_path)  # Use file:/// prefix to open local file

    @classmethod
    def tearDownClass(cls):
        cls.driver.quit()

    def test_valid_login(self):
        self.driver.find_element(By.ID, "username").send_keys("testuser")
        self.driver.find_element(By.ID, "password").send_keys("testpass")
        self.driver.find_element(By.ID, "login-btn").click()
        self.assertTrue(self.driver.page_source.find("Logged in successfully"), "Valid login failed!")

    def test_invalid_login(self):
        self.driver.find_element(By.ID, "username").send_keys("testuser")
        self.driver.find_element(By.ID, "password").send_keys("wrongpass")
        self.driver.find_element(By.ID, "login-btn").click()
        self.assertTrue(self.driver.page_source.find("Invalid credentials"), "Invalid login succeeded!")


if __name__ == "__main__":
    unittest.main()

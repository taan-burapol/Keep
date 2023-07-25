import random
import string
import secrets
import base64
import datetime


def generate_license_key(key_length=20, expiration_days=30):
    characters = string.ascii_uppercase + string.digits
    license_key = ''.join(secrets.choice(characters) for _ in range(key_length))

    # Add an expiration date to the license key
    expiration_date = datetime.date.today() + datetime.timedelta(days=expiration_days)
    license_key += f"_{expiration_date}"

    return license_key


def encrypt_license_key(license_key, encryption_key):
    encrypted_key_bytes = bytearray(x ^ encryption_key for x in license_key.encode())
    return base64.urlsafe_b64encode(encrypted_key_bytes).decode()


def save_license_key(encrypted_key, filename="license_key.txt"):
    with open(filename, "w") as file:
        file.write(encrypted_key)


if __name__ == "__main__":
    # Example encryption key (You should use your own secure encryption key)
    encryption_key = 42

    license_key = generate_license_key()
    encrypted_key = encrypt_license_key(license_key, encryption_key)
    save_license_key(encrypted_key)
    print("License key generated and encrypted. Saved to 'license_key.txt'.")

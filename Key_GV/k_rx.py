import base64
import datetime


def read_license_key(filename="license_key.txt"):
    try:
        with open(filename, "r") as file:
            return file.readline().strip()
    except FileNotFoundError:
        return None


def decrypt_license_key(encrypted_key, encryption_key):
    encrypted_key_bytes = base64.urlsafe_b64decode(encrypted_key.encode())
    decrypted_key = ''.join(chr(x ^ encryption_key) for x in encrypted_key_bytes)
    return decrypted_key


def encrypt_license_key(license_key, encryption_key):
    encrypted_key_bytes = bytearray(x ^ encryption_key for x in license_key.encode())
    return base64.urlsafe_b64encode(encrypted_key_bytes).decode()


def save_license_key(encrypted_key, filename="license_key.txt"):
    with open(filename, "w") as file:
        file.write(encrypted_key)


def validate_license_key(license_key):
    if not license_key:
        return False

    # Get the expiration date and usage flag from the license key
    parts = license_key.split('_')
    if len(parts) != 2:
        return False

    expiration_date_str = parts[1]
    try:
        expiration_date = datetime.datetime.strptime(expiration_date_str, "%Y-%m-%d").date()
        if datetime.date.today() > expiration_date:
            return False
    except ValueError:
        return False

    # Check if the key has already been used (marked as used)
    if parts[0].endswith('-used'):
        return False

    return True


def mark_license_key_as_used(license_key):
    parts = license_key.split('_')
    if not parts[0].endswith('-used'):
        parts[0] += '-used'
    return '_'.join(parts)


if __name__ == "__main__":
    # Example encryption key (should match the key used for generation)
    encryption_key = 42

    encrypted_license_key = read_license_key()
    if encrypted_license_key is not None:
        decrypted_license_key = decrypt_license_key(encrypted_license_key, encryption_key)
        if validate_license_key(decrypted_license_key):
            print("License key is valid.")
            # Mark the license key as used (one-time license)
            encrypted_license_key = encrypt_license_key(mark_license_key_as_used(decrypted_license_key), encryption_key)
            save_license_key(encrypted_license_key)
            print("License key has been marked as used.")
        else:
            print("License key is not valid or has expired.")
    else:
        print("No license key found. Please generate a license key first.")

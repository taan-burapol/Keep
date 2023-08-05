import marshal


def read_compiled_bytecode(pyc_file_path):
    try:
        with open(pyc_file_path, "rb") as pyc_file:
            bytecode = marshal.load(pyc_file)
        return bytecode
    except Exception as e:
        print(f"Error reading the compiled bytecode: {e}")
        return None


def execute_bytecode(bytecode, globals_dict, locals_dict):
    try:
        exec(bytecode, globals_dict, locals_dict)
    except Exception as e:
        print(f"Error executing the bytecode: {e}")


# Path to the .pyc file
pyc_file_path = "example.pyc"

# Read the compiled bytecode from the .pyc file
bytecode = read_compiled_bytecode(pyc_file_path)

# Check if the bytecode was read successfully
if bytecode:
    # Define the globals and locals dictionaries with arguments
    globals_dict = {}
    locals_dict = {}  # The argument to example_function

    # Execute the bytecode with arguments
    execute_bytecode(bytecode, globals_dict, locals_dict)

    # Call the example_function from the executed code
    if 'example_function' in locals_dict:
        example_function = locals_dict['example_function']
        opt = example_function('Tim')  # Call example_function with argument 'Tim'
        print(opt)
else:
    print("Failed to read the compiled bytecode.")

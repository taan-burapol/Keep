import os
import sys
import timeit

# Python script for execute
script_path = os.path.join(os.path.dirname(sys.argv[0]), "bytecode_jit_function.py")

with open(script_path, 'r') as file:
    script_code = file.read()


def sum_of_squares_py(n):
    result = 0
    for i in range(1, n + 1):
        result += i * i
    return result


# Benchmarking the original Python function
def benchmark_py(n):
    return sum_of_squares_py(n)


# Benchmarking the Numba JIT-compiled function
def benchmark_numba(n):
    function_name = 'sum_of_squares_numba'
    # Inject the function_name and arguments into the script_code
    return exec(script_code.format(function_name, n))


def run_benchmarks():
    n = 500000
    run_num = 100

    py_time = timeit.timeit(lambda: benchmark_py(n), number=run_num)
    numba_time = timeit.timeit(lambda: benchmark_numba(n), number=run_num)
    print("Time taken by the original Python function:", py_time)
    print("Time taken by the JIT-compiled function:", numba_time)


run_benchmarks()

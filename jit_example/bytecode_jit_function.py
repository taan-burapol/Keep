import numba as nb


@nb.jit(nopython=True)
def sum_of_squares_numba(n):
    result = 0
    for i in range(1, n + 1):
        result += i * i
    return result


# function_name = '{}'
# arg1 = '{}'
# if function_name == 'sum_of_squares_numba':
#     sum_of_squares_numba(int(arg1))
# else:
#     print("Unknown function name.")

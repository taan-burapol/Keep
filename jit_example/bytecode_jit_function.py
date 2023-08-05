import numba as nb


@nb.jit(nopython=True)
def sum_of_squares_numba(n):
    result = 0
    for i in range(1, n + 1):
        result += i * i
    return result

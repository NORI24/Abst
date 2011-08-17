# Triangle numbers are generated by the formula, T_n = n * (n + 1) / 2.
# The first ten triangle numbers are:
#     1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...
def triangle?(n)
	return false unless r = square?((n << 3) + 1) and 0 == (-1 + r)[0]
	return true
end

# Pentagonal numbers are generated by the formula, P_n = n * (3 * n - 1) / 2.
# The first ten pentagonal numbers are:
#     1, 5, 12, 22, 35, 51, 70, 92, 117, 145, ...
def pentagonal?(n)
	return false unless r = square?(24 * n + 1) and 0 == (1 + r) % 6
	return true
end

# Hexagonal numbers are generated by the formula, H_n = n * (2 * n - 1)
# The first ten hexagonal numbers are:
#     1, 6, 15, 28, 45, 66, 91, 120, 153, 190, ...
def hexagonal?(n)
	return false unless r = square?((n << 3) + 1) and 0 == (1 + r) & 3
	return true
end
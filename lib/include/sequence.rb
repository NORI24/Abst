module Abst
	module_function

	$fibonacci = {0 => 0, 1 => 1}

	# Param::  non-negative integer n
	# Return:: the n-th Fibonacci number
	# effect $fibonacci[n] = fibonacci(n)
	def fibonacci(n)
		return $fibonacci[n] if $fibonacci.include?(n)

		m = n >> 1
		if n.even?
			f1 = fibonacci(m - 1)
			f2 = fibonacci(m)
			$fibonacci[n] = (f1 + f1 + f2) * f2
		else
			f1 = fibonacci(m)
			f2 = fibonacci(m + 1)
			$fibonacci[n] = f1 ** 2 + f2 ** 2
		end

		return $fibonacci[n]
	end

	# Triangle numbers are generated by the formula, T_n = n * (n + 1) / 2.
	# The first ten triangle numbers are:
	#     1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...
	def triangle(n)
		return n * (n + 1) >> 1
	end

	# Pentagonal numbers are generated by the formula, P_n = n * (3 * n - 1) / 2.
	# The first ten pentagonal numbers are:
	#     1, 5, 12, 22, 35, 51, 70, 92, 117, 145, ...
	def pentagonal(n)
		return n * (3 * n - 1) >> 1
	end

	# Hexagonal numbers are generated by the formula, H_n = n * (2 * n - 1)
	# The first ten hexagonal numbers are:
	#     1, 6, 15, 28, 45, 66, 91, 120, 153, 190, ...
	def hexagonal(n)
		return n * ((n << 1) - 1)
	end

	def heptagonal(n)
		return n * (5 * n - 3) >> 1
	end

	def octagonal(n)
		return n * (3 * n - 2)
	end
end

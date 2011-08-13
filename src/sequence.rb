$fibonacci = {0 => 0, 1 => 1}

# Param::  non-negative integer n
# Return:: the n-th Fibonacci number
# effect $fibonacci[n] = fibonacci(n)
def fibonacci(n)
	return $fibonacci[n] if $fibonacci.include?(n)

	m = n > 1
	if n[0] == 0
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
